//
//  SwipeViewController.swift
//  matterOfdebate
//
//  Created by Gregor Anzer on 18.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SwipeViewController: UIViewController {
    
    @IBOutlet weak var swipeContainer: UIView!
    @IBOutlet weak var imgSwipe: UIImageView!
    @IBOutlet weak var labelSwipe: UILabel!
    @IBOutlet weak var swipeText: UITextField!
    @IBOutlet weak var swipeNoButton: UIButton!
    @IBOutlet weak var swipeYesButton: UIButton!
    @IBOutlet var topView: UIView!
    var gestureStart: CGPoint?
    var gestureEnd: CGPoint?
    var defaultPos: CGPoint?
    public var selectedCat: String?
    private var topics: [Topic] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //shadows for the card
        swipeContainer.layer.shadowColor = UIColor.black.cgColor
        swipeContainer.layer.shadowOpacity = 0.3
        swipeContainer.layer.shadowOffset = CGSize.init(width: 0, height: 6)
        swipeContainer.layer.shadowRadius = 15
        //move buttons under the card
        topView.sendSubview(toBack: swipeNoButton)
        topView.sendSubview(toBack: swipeYesButton)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeText.text = "This is an example test and should be replaced by the time you see this view."
        getThemesOfCategory(selectedCat!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        defaultPos = swipeContainer.center
        if topics.count > 0 {
            swipeText.text = topics[0].description
            labelSwipe.text = topics[0].title
            
        }
    }

    @IBAction func handleTapNo(_ sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.ended)
        {
            swipeNo()
        }
    }
    @IBAction func handleTapYes(_ sender: UITapGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.ended) {
            swipeYes()
        }
    }
    

    @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer)
    {
        let velocity = sender.velocity(in: sender.view)
        switch (sender.state) {
        case UIGestureRecognizerState.began:
            break
        case .possible:
            break
        case .changed:
//            print(sender.velocity(in: sender.view))
            //moving the card
            let translation = sender.translation(in: topView)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
            break
        case .ended:
            if(isGestureValid(velocity: velocity)) {
                if(velocity.x > 0) {
                    swipeYes()
                } else {
                    swipeNo()
                }
            } else {
                UIViewPropertyAnimator.init(duration: 0.3, curve: UIViewAnimationCurve.easeIn, animations: {
                    self.swipeContainer.center = CGPoint(x:(self.defaultPos?.x)!, y:(self.defaultPos?.y)!)
                }).startAnimation()
            }
            break
        case .cancelled:
           break
        case .failed:
            break
        }
    }

    func swipeYes() {
        print("yes")
        let animator = UIViewPropertyAnimator.init(duration: 0.5, curve: UIViewAnimationCurve.easeIn, animations: {
            self.swipeContainer.center = self.swipeYesButton.center
            self.swipeContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.swipeContainer.alpha = 0.01
        })
        animator.startAnimation()
        self.performSegue(withIdentifier: "toOpinion", sender: self)
    }

    func swipeNo() {
        print("NO")
        let sourceView = self.swipeContainer
        //TODO For custom SwipeContainerView
        let copiedView = sourceView?.copyView()
        print(copiedView?.constraints.description)
        copiedView!.backgroundColor = UIColor.red
        copiedView!.center = defaultPos!
        copiedView!.updateConstraintsIfNeeded()
        let animator = UIViewPropertyAnimator.init(duration: 0.6, curve: UIViewAnimationCurve.easeOut, animations: {
            self.swipeContainer!.center = self.swipeNoButton.center
            self.swipeContainer!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.swipeContainer!.alpha = 0.01
        })
        animator.startAnimation()
        
        //TODO add a dismissed mark to topic data
        //reloadCard()
        //TODO Load new Subject/Theme
    }

    // Ist die Geste lange und schnell genug um unmissverständlich zu sein?
    func isGestureValid(velocity: CGPoint) -> Bool {
        if (velocity.y > 300) {
                return true
        }
        return false
    }
    
    func reloadCard() {
        self.swipeContainer.center = defaultPos!
        self.swipeContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.swipeContainer.alpha = 1
        return
    }
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    class Direction {
        // direction is one for downleft
        //  two for downright, zero for not needed direction for swipe
        static let downRight: Int = 2
        static let downLeft: Int = 1
        static let up: Int = 0
        let direction: CGVector
        
        init(velocity: CGPoint) {
            direction = CGVector.init(dx: velocity.x, dy: velocity.y)
        }
        
        func getDirection() -> Int {
            if(direction.dy > 0) {
                if(direction.dx > 0) {
                    //direction to bottom left
                    return Direction.downLeft
                } else {
                    return Direction.downRight
                }
            } else {
                return Direction.up
            }
        }
    }
    
    func getThemesOfCategory(_ theme_id: String) {
        
        let themesRef = Constants.refs.databaseThemes
        let themesUpdateHandle = themesRef.queryOrdered(byChild: "categories/" + theme_id)
            .queryEqual(toValue: true)
            .observe(.childAdded, with: { (snapshot) -> Void in
                
                let themesData = snapshot.value as! Dictionary<String, AnyObject>
                let t_title = themesData["titel"] as? String ?? ""
                let img_url = themesData["img-url"] as? String ?? ""
                let description = themesData["description"] as? String ?? ""
                
                let topic = Topic(name: t_title, description: description, categories: [theme_id], imageUrl: img_url, id: snapshot.key)
                
                self.topics.append(topic)
            })
    }
    
}
