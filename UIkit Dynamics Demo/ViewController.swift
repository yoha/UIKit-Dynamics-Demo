//
//  ViewController.swift
//  UIkit Dynamics Demo
//
//  Created by Yohannes Wijaya on 7/25/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Stored properties
    
    var greenBox: UIView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var panGesture: UIPanGestureRecognizer!
    var attachBehavior: UIAttachmentBehavior!
    var boxDynamicBehavior: UIDynamicItemBehavior!
    let boxDynamicBehaviorElasticityLevel: CGFloat = 0.5 // [0 -> 1] higher # leads to bouncier
    let boxDynamicBehaviorAngularResistanceLevel: CGFloat = 0 //  higher # less rotation

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate the green box
        self.greenBox = UIView()
        self.greenBox.backgroundColor = UIColor.greenColor()
        self.greenBox.frame = CGRect(x: CGRectGetMidX(self.view.frame) - 50, y: CGRectGetMidY(self.view.frame) - 50, width: 100, height: 100)
        self.view.addSubview(self.greenBox)
        
        // Instantiate the animation, gravity, & collision behavior
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravity = UIGravityBehavior(items: [self.greenBox])
        self.collision = UICollisionBehavior(items: [self.greenBox])
        self.collision.translatesReferenceBoundsIntoBoundary = true
        
        // Pass the gravity & collision behavior to the animator
        self.animateWithGravityAndCollisionBehavior(self.animator, behavior: (self.gravity, self.collision))
        
        // Instantiate the gesture recognizer & assign it to the green box
        self.panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        self.greenBox.addGestureRecognizer(self.panGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Local methods
    
    func panning(panningGesture: UIPanGestureRecognizer) {
        let draggedPointLocationRelativeToMainView = panningGesture.locationInView(self.view)
        let draggedPointLocationRelativeToGreenBox = panningGesture.locationInView(self.greenBox)
        if panningGesture.state == UIGestureRecognizerState.Began {
            self.animator.removeAllBehaviors() // remove collision and gravity attributes so that the box can be moved freely around the screen
            let touchLocationInGreenBoxOffset = UIOffset(horizontal: draggedPointLocationRelativeToGreenBox.x - CGRectGetMidX(self.greenBox.bounds), vertical: draggedPointLocationRelativeToGreenBox.y - CGRectGetMidY(self.greenBox.bounds))
            self.attachBehavior = UIAttachmentBehavior(item: self.greenBox, offsetFromCenter: touchLocationInGreenBoxOffset, attachedToAnchor: draggedPointLocationRelativeToMainView)
            self.animator.addBehavior(self.attachBehavior)
        }
        else if panningGesture.state == UIGestureRecognizerState.Changed {
            self.attachBehavior.anchorPoint = draggedPointLocationRelativeToMainView
        }
        else if panningGesture.state == UIGestureRecognizerState.Ended {
            self.animator.removeBehavior(self.attachBehavior)
            self.boxDynamicBehavior = UIDynamicItemBehavior(items: [self.greenBox])
            self.boxDynamicBehavior.addLinearVelocity(panningGesture.velocityInView(self.view), forItem: self.greenBox)
            self.boxDynamicBehavior.elasticity = self.boxDynamicBehaviorElasticityLevel
            self.boxDynamicBehavior.angularResistance = self.boxDynamicBehaviorAngularResistanceLevel
            self.animator.addBehavior(self.boxDynamicBehavior)
            
            
            // since all behaviors have been removed (#56), re-add them
            self.animateWithGravityAndCollisionBehavior(self.animator, behavior: (self.gravity, self.collision))
        }
    }
    
    func animateWithGravityAndCollisionBehavior(animator: UIDynamicAnimator, behavior: (type1: UIDynamicBehavior, type2: UIDynamicBehavior)) {
        animator.addBehavior(behavior.type1)
        animator.addBehavior(behavior.type2)
    }
}

