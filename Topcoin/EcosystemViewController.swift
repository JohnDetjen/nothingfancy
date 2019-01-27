//
//  EcosystemViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/19/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit

class EcosystemViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tokensDistributedLabel: UILabel!
    @IBOutlet weak var tokenCountLabel: UILabel!
    @IBOutlet weak var walletHoldersLabel: UILabel!
    @IBOutlet weak var walletCountLabel: UILabel!
    @IBOutlet weak var walletHoldersTop: NSLayoutConstraint!
    @IBOutlet weak var tokensDistributedLeading: NSLayoutConstraint!
    @IBOutlet weak var tokensDistributedTop: NSLayoutConstraint!
    @IBOutlet weak var applyButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var applyButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var applyButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var over90DaysLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            
            tokensDistributedLabel.font = UIFont(name: "Arial", size: 55)
            tokenCountLabel.font = UIFont(name: "Arial", size: 45)
            walletHoldersLabel.font = UIFont(name: "Arial", size: 55)
            walletCountLabel.font = UIFont(name: "Arial", size: 45)
            walletHoldersTop.constant = 50
            tokensDistributedLeading.constant = 70
            tokensDistributedTop.constant = 70
            applyButtonHeight.constant = 80
            applyButtonLeading.constant = 100
            applyButtonTrailing.constant = 100
            applyButton.titleLabel?.font = UIFont(name: "Arial", size: 28)
            over90DaysLabel.font = UIFont(name: "Arial", size: 20)
            
            
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            
        }
        
        //iPad Air, 5th Gen
        if view.frame.width == 768 {
            
        }
        
        //        //iphone 5
        //        if view.frame.width == 320 {
        //        }

        applyButton.layer.cornerRadius = 0.5 * applyButtonHeight.constant
        applyButton.clipsToBounds = true
        
    }
    
    func addReusableViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ReusableViewController.self)) as? ReusableViewController else { return }
        vc.willMove(toParent: self)
        addChild(vc)
        containerView.addSubview(vc.view)
        constraintViewEqual(view1: containerView, view2: vc.view)
        vc.didMove(toParent: self)
    }
    
    /// Sticks child view (view1) to the parent view (view2) using constraints.
    private func constraintViewEqual(view1: UIView, view2: UIView) {
        view2.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0)
        let constraint2 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)
        let constraint3 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)
        let constraint4 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0)
        view1.addConstraints([constraint1, constraint2, constraint3, constraint4])
    }

}
