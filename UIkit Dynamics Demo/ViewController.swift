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
    
    var greenBox: UIView?
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate the green box
        self.greenBox = UIView()
        self.greenBox?.backgroundColor = UIColor.greenColor()
        self.greenBox?.frame = CGRect(x: CGRectGetMidX(self.view.frame) - 50, y: CGRectGetMidY(self.view.frame) - 50, width: 100, height: 100)
        self.view.addSubview(self.greenBox!)
        
        // Instantiate the animation, gravity, & collision behavior
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravity = UIGravityBehavior(items: [self.greenBox!])
        self.collision = UICollisionBehavior(items: [self.greenBox!])
        self.collision?.translatesReferenceBoundsIntoBoundary = true
            
        // Pass the gravity & collision behavior to the animator
        self.animator!.addBehavior(self.gravity!)
        self.animator!.addBehavior(self.collision!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

