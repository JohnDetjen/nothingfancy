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
    
    static var instance: ReusableViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.shard1.frame.origin.y -= self.view.frame.maxY + 170
        }, completion: nil)
        self.shard2.frame.origin.y = view.frame.maxY
        UIView.animate(withDuration: 15, delay: 0.0, options: [.repeat], animations: {
            self.shard2.frame.origin.y -= self.view.frame.maxY + 120
        }, completion: nil)
        self.shard3.frame.origin.y = view.frame.maxY
        UIView.animate(withDuration: 22, delay: 1.5, options: [.repeat], animations: {
            self.shard3.frame.origin.y -= self.view.frame.maxY + 150
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
