//
//  SwipeViewController.swift
//  matterOfdebate
//
//  Created by Gregor Anzer on 18.12.17.
//  Copyright © 2017 Gruppe7. All rights reserved.
//

import Foundation
import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swipeContainer.layer.shadowColor = UIColor.black.cgColor
        swipeContainer.layer.shadowOpacity = 0.3
        swipeContainer.layer.shadowOffset = CGSize.init(width: 0, height: 6)
        swipeContainer.layer.shadowRadius = 15
        topView.sendSubview(toBack: swipeNoButton)
        topView.sendSubview(toBack: swipeYesButton)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeText.text = "This is an example test and should be replaced by the time you see this view."
    }

    @IBAction func handleTapNo(_ sender: UITapGestureRecognizer) {
        if(sender.state == UIGestureRecognizerState.ended)
        {
            print("you tapped no")
        }
    }
    @IBAction func handleTapYes(_ sender: UITapGestureRecognizer){
        if(sender.state == UIGestureRecognizerState.ended) {
            print("you tapped yes");
        }
    }
    @IBAction func handleSwipe(_ sender: UIPanGestureRecognizer)
    {

        switch (sender.state) {
        case UIGestureRecognizerState.began:
            gestureStart = sender.translation(in: topView)
            print(gestureStart!)
            break
        case .possible:
            break
        case .changed:
            let translation = sender.translation(in: topView)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.view)
            break
        case .ended:
            gestureEnd = sender.translation(in: topView)
            // entscheide ob richtige gesture
            if isGestureValid(begin: gestureStart!, end: gestureEnd!) {
                let dir = Direction.init(one: gestureStart!, two: gestureEnd!).getDirection()
                switch dir {
                case Direction.downLeft:
                    swipeNo()
                case Direction.downRight:
                    swipeYes()
                default:
                    view.center = CGPoint(x:view.center.x + (defaultPos?.x)!, y:view.center.y + (defaultPos?.y)!)
                }
            }
            break
        case .cancelled:
           break
        case .failed:
            break
        }
    }
    
    func swipeYes() {
        
    }
    
    func swipeNo() {
        
    }
    
    func isGestureValid(begin: CGPoint, end: CGPoint) -> Bool {
        let direction = Direction.init(one: begin, two: end).getDirection()
        if distanceBetweenPoints(one: begin, two: end) >= (swipeContainer.frame.width/2) {
            if(direction != Direction.up) {
                return true;
            }
        }
        return false
    }
    
    func distanceBetweenPoints(one: CGPoint, two: CGPoint) ->CGFloat {
        let deltaX = abs(one.x - two.x)
        let deltaY = abs(one.y - two.y)
        let distance: CGFloat = sqrt(pow(deltaX, 2)+pow(deltaY, 2))
        return distance
    }
    
    class Direction {
        // direction is one for downleft
        //  two for downright, zero for not needed direction for swipe
        static let downRight: Int = 2
        static let downLeft: Int = 1
        static let up: Int = 0
        let direction: CGVector
        
        init(one: CGPoint, two: CGPoint) {
            direction = CGVector.init(dx: one.x-two.y, dy: one.y-two.y)
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
    
}
