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
    
    weak var delegate: TabBarDelegate?
    
    @IBOutlet weak var swipeContainer: UIView!
    @IBOutlet weak var imgSwipe: UIImageView!
    @IBOutlet weak var labelSwipe: UILabel!
    @IBOutlet weak var swipeTextView: UITextView!
    @IBOutlet weak var swipeNoButton: UIButton!
    @IBOutlet weak var swipeYesButton: UIButton!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var noThemesView: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    var defaultPos: CGPoint?
    public var selectedCat: String?
    private var topics: [Topic] = []
    private var topicCounter: Int = 0
    private let storage = Storage.storage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //shadows for the card
        swipeContainer.layer.shadowColor = UIColor.black.cgColor
        swipeContainer.layer.shadowOpacity = 0.3
        swipeContainer.layer.shadowOffset = CGSize.init(width: 0, height: 6)
        swipeContainer.layer.shadowRadius = 15
        swipeContainer!.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        swipeContainer.isHidden = true
        //Fixing UILabel for multiline text
        labelSwipe.lineBreakMode = .byWordWrapping
        labelSwipe.numberOfLines = 0
        //move buttons under the card
        topView.sendSubview(toBack: swipeNoButton)
        topView.sendSubview(toBack: swipeYesButton)
        
        
        if(SingletonUser.sharedInstance.user.isAnonymous) {
            noThemesView.isHidden = false
            errorMessage.text = "Nur für registrierte Nutzer"
        } else {
            noThemesView.isHidden = true
            errorMessage.text = "Keine Themen mehr"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!SingletonUser.sharedInstance.user.isAnonymous) {
            getThemesOfCategory(selectedCat!)
        } else {
            self.topics = []
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        defaultPos = swipeContainer.center
        if topics.count > 0 {
            swipeTextView.text = topics[0].description
            labelSwipe.text = topics[0].title
            let url = self.storage.reference(forURL: topics[0].imageUrl)
            imgSwipe.sd_setImage(with: url, placeholderImage: nil)
            topicCounter = 0
            swipeContainer.isHidden = false
            swipeContainer.alpha = 0.001
            UIView.animate(withDuration: 0.2, animations: {
                self.swipeContainer!.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.swipeContainer!.alpha = 1
            }, completion: {(true) in
                
            })
        } else {
            if(!SingletonUser.sharedInstance.user.isAnonymous) {
                noThemesView.isHidden = false
                
            }
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
        animateCardTo(view: swipeYesButton)
        if noThemesView.isHidden {
            self.performSegue(withIdentifier: "toOpinion", sender: topics[topicCounter])
        }
    }
    
    @IBAction func backToCat(_ sender: UIButton) {
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func backToCatAnon(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    fileprivate func prepareCardReset() {
        self.swipeContainer.center = CGPoint(x:(self.defaultPos?.x)!, y:(self.defaultPos?.y)!)
        self.swipeContainer!.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.swipeContainer!.alpha = 0
        topicCounter = topicCounter+1
        if topicCounter < topics.count {
            self.swipeTextView.text = topics[topicCounter].description
            self.labelSwipe.text = topics[topicCounter].title
            let url = self.storage.reference(forURL: topics[topicCounter].imageUrl)
            imgSwipe.sd_setImage(with: url, placeholderImage: UIImage(named: "Image"))
            UIView.animate(withDuration: 0.2, animations: {
                self.swipeContainer!.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.swipeContainer!.alpha = 1
            }, completion: {(true) in
                
            })
        } else {
            noThemesView.isHidden = false
        }
    }
    
    @IBAction func back(_ sender: UITapGestureRecognizer) {
        print("back")
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func animateCardTo(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.swipeContainer!.center = view.center
            self.swipeContainer!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.swipeContainer!.alpha = 0.001
        }, completion: {(true) in
            self.prepareCardReset()
        })
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let viewController = segue.destination as? OpinionController {
            viewController.selectedTopic = topics[topicCounter]
            viewController.delegate = self
        }
    }
    
    func swipeNo() {
        print("NO")
        animateCardTo(view: swipeNoButton)
        //TODO add a dismissed mark to topic data
        //resetCard()
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
        
        self.topics = []
        var tempTopics:[Topic] = []
        
        //retrieving topics
        let themesRef = Constants.refs.databaseThemes
        _ = themesRef.queryOrdered(byChild: "categories/" + theme_id)
            .queryEqual(toValue: true)
            .observe(.childAdded, with: { (snapshot) -> Void in
                
                let themesData = snapshot.value as! Dictionary<String, AnyObject>
                let t_title = themesData["titel"] as? String ?? ""
                let img_url = themesData["img-url"] as? String ?? ""
                let description = themesData["description"] as? String ?? ""
                
                let topic = Topic(name: t_title, description: description, categories: [theme_id], imageUrl: img_url, id: snapshot.key)
                
                tempTopics.append(topic)
            })
        
        // only add topic if user has no opinion yet
        Constants.refs.databaseUsers.observe(DataEventType.value) { (userSnap) in let dictionary = userSnap.value as? [String : AnyObject]
            let userID = SingletonUser.sharedInstance.user.uid
            let user = dictionary![userID]
            if let opinions = user!["opinions"] as? [String : Int] {
                print("opinions counter: \(opinions.count)")
            for topic in tempTopics {
                if self.alreadyHasOpinion(id: topic.id, array: opinions.keys) {
                    print("useralready has opinion on \(topic.id)")
                } else {
                    self.topics.append(topic)
                }
            }
            } else {
                if(!SingletonUser.sharedInstance.user.isAnonymous) {
                    self.topics += tempTopics
                }
            }
        }
    }
    
    // checking if id is in array
    func alreadyHasOpinion(id: String, array: Dictionary<String,Int>.Keys) -> Bool {
        for opinion in array {
            if opinion == id {
                return true
            }
        }
        return false
    }
}

extension SwipeViewController: TabBarDelegate {
    
    func switchToTab(_ index: Int) {
         delegate?.switchToTab(index)
    }
}
