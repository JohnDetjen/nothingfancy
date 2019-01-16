//
//  CheckEmailResetPasswordViewController.swift
//  Topcoin
//
//  Created by John Detjen on 1/16/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit

class CheckEmailResetPasswordViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        signInButton.layer.cornerRadius = 25.0
        signInButton.clipsToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        addReusableViewController()
    }
    
    func addReusableViewController() {
        guard let vc = ReusableViewController.getInstance(storyboard: storyboard) else { return }
        //        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ReusableViewController.self)) as? ReusableViewController else { return }
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

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
