//
//  ReusableViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/26/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit

class ReusableViewController: UIViewController {
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var shard1: UIImageView!
    @IBOutlet weak var shard2: UIImageView!
    @IBOutlet weak var shard3: UIImageView!
    @IBOutlet weak var shard1Height: NSLayoutConstraint!
    @IBOutlet weak var shard2Height: NSLayoutConstraint!
    @IBOutlet weak var shard3Height: NSLayoutConstraint!
    
    static var instance: ReusableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            shard1Height.constant = 450
            shard2Height.constant = 300
            shard3Height.constant = 380
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            shard1Height.constant = 380
            shard2Height.constant = 260
            shard3Height.constant = 340
        }
        
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x:1, y:1)
        gradientView.layer.addSublayer(layer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.shard1.frame.origin.y = view.frame.maxY
        UIView.animate(withDuration: 40, delay: 2.4, options: [.repeat], animations: {
            self.shard1.frame.origin.y -= self.view.frame.maxY + self.shard1Height.constant
        }, completion: nil)
        self.shard2.frame.origin.y = view.frame.maxY
        UIView.animate(withDuration: 15, delay: 0.0, options: [.repeat], animations: {
            self.shard2.frame.origin.y -= self.view.frame.maxY + self.shard2Height.constant
        }, completion: nil)
        self.shard3.frame.origin.y = view.frame.maxY
        UIView.animate(withDuration: 22, delay: 1.5, options: [.repeat], animations: {
            self.shard3.frame.origin.y -= self.view.frame.maxY + self.shard3Height.constant
        }, completion: nil)
    }
    
    static func getInstance(storyboard: UIStoryboard?) -> ReusableViewController? {
        if ReusableViewController.instance == nil {
            ReusableViewController.instance = storyboard?.instantiateViewController(withIdentifier: String(describing: ReusableViewController.self)) as? ReusableViewController
            print(ReusableViewController.instance)
        }
        return ReusableViewController.instance
    }

}
