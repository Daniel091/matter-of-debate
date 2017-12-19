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
        case .ended:
            break
        case .cancelled:
           break
        case .failed:
            break
        }
    }
    
    func distanceBetweenPoints(one: CGPoint, two: CGPoint) ->CGFloat {
        let deltaX = abs(one.x - two.x)
        let deltaY = abs(one.y - two.y)
        let distance: CGFloat = sqrt(pow(deltaX, 2)+pow(deltaY, 2))
        return distance
    }
}
