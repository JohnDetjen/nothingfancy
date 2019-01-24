//
//  WelcomeViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/20/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import SafariServices

class WelcomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var logInButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var logInButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var logInButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var privacyTop: NSLayoutConstraint!
    @IBOutlet weak var privacyBottom: NSLayoutConstraint!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var logoTop: NSLayoutConstraint!
    @IBOutlet weak var logoLeading: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinTextLogo: UILabel!
    @IBOutlet weak var descriptionText: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            logoTop.constant = 200
            logoLeading.constant = 100
            logoHeight.constant = 100
            logIn.titleLabel?.font = UIFont(name: "Arial", size: 28)
            topcoinTextLogo.font = UIFont(name: "Arial Rounded MT Bold", size: 60)
            descriptionText.font = UIFont(name: "Arial", size: 35)
            logInButtonHeight.constant = 90
            logInButtonLeading.constant = 100
            logInButtonTrailing.constant = 100
            privacyTop.constant = 30
            privacyBottom.constant = 60
            privacyButton.titleLabel?.font = UIFont(name: "Arial", size: 24)
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            logoTop.constant = 160
            logoLeading.constant = 90
            logoHeight.constant = 85
            logIn.titleLabel?.font = UIFont(name: "Arial", size: 25)
            topcoinTextLogo.font = UIFont(name: "Arial Rounded MT Bold", size: 50)
            descriptionText.font = UIFont(name: "Arial", size: 30)
            logInButtonHeight.constant = 80
            logInButtonLeading.constant = 90
            logInButtonTrailing.constant = 90
            privacyTop.constant = 30
            privacyBottom.constant = 60
            privacyButton.titleLabel?.font = UIFont(name: "Arial", size: 20)
        }
        
        //iPad Air, 5th Gen
        if view.frame.width == 768 {
            logoTop.constant = 160
            logoLeading.constant = 90
            logoHeight.constant = 85
            logIn.titleLabel?.font = UIFont(name: "Arial", size: 25)
            topcoinTextLogo.font = UIFont(name: "Arial Rounded MT Bold", size: 50)
            descriptionText.font = UIFont(name: "Arial", size: 30)
            logInButtonHeight.constant = 80
            logInButtonLeading.constant = 90
            logInButtonTrailing.constant = 90
            privacyTop.constant = 30
            privacyBottom.constant = 60
            privacyButton.titleLabel?.font = UIFont(name: "Arial", size: 20)
        }
        
        //        //iphone 5
        //        if view.frame.width == 320 {
        //            logIn.titleLabel?.font = UIFont(name: "System", size: 15)
        //            logInButtonHeight.constant = 50
        //            logInButtonLeading.constant = 25
        //            logInButtonTrailing.constant = 25
        //            privacyTop.constant = 10
        //            privacyBottom.constant = 5
        //            privacyButton.titleLabel?.font = UIFont(name: "System", size: 9)
        //        }
        
        logIn.layer.cornerRadius = 0.5 * logInButtonHeight.constant
        logIn.clipsToBounds = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    
    @IBAction func privacyButtonPressed(_ sender: Any) {
        
        if let url = URL(string: "https://topcoin.network/privacy") {
            let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(svc, animated: true, completion: nil)
        }
        
    }
    
  

}
