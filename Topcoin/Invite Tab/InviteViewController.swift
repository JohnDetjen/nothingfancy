//
//  InviteViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/6/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class InviteViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

 
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sendEmail: UIButton!
    @IBOutlet weak var sendText: UIButton!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var copyLink: UIButton!
    @IBOutlet weak var sendEmailHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
//            sendEmailHeight.constant = 80
            
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            
        }
        
        //iPad Air, 5th Gen
        if view.frame.width == 768 {
            
        }
        
                //iphone 5
        if view.frame.width == 320 {
        }
        
        
        
        sendEmail.layer.cornerRadius = 4
        if #available(iOS 11.0, *) {
            sendEmail.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            self.sendEmail.clipsToBounds = true
            let path = UIBezierPath(roundedRect: sendEmail.bounds,
                                    byRoundingCorners: [.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 20, height: 20))
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            sendEmail.layer.mask = maskLayer
        }
        
        copyLink.layer.cornerRadius = 4
        if #available(iOS 11.0, *) {
            copyLink.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            self.copyLink.clipsToBounds = true
            let path = UIBezierPath(roundedRect: copyLink.bounds,
                                    byRoundingCorners: [.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 20, height: 20))
            
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            copyLink.layer.mask = maskLayer
        }
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
    
    @IBAction func sendEmailPressed(_ sender: Any) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("Inviting you to Topcoin")
        mailComposerVC.setMessageBody("Hey,\n\nI've been using Topcoin to get discounts on digital goods such as domains, hosting, SSL, website creation and more.\n\nSign up now and get 100 free Topcoin.\n\nClaim your invite now:\nhttp://bit.ly/topcoinrewards\n\nLet me know if you need help.\nThanks.", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendTextPressed(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey,\n\nI've been using Topcoin to get discounts on digital goods such as domains, hosting, SSL, website creation and more.\n\nSign up now and get 100 free Topcoin.\n\nClaim your invite now:\n\n\nLet me know if you need help.\nThanks."
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func sharePressed(_ sender: Any) {
        "Hey,\n\nI've been using Topcoin to get discounts on digital goods such as domains, hosting, SSL, website creation and more.\n\nSign up now and get 100 free Topcoin.\n\nClaim your invite now:\nhttp://bit.ly/topcoinrewards\n\nLet me know if you need help.\nThanks.".share()
    }
    
    
    @IBAction func copyLink(_ sender: Any) {
        UIPasteboard.general.string = "Hey,\n\nI've been using Topcoin to get discounts on digital goods such as domains, hosting, SSL, website creation and more.\n\nSign up now and get 100 free Topcoin.\n\nClaim your invite now:\nhttp://bit.ly/topcoinrewards\n\nLet me know if you need help.\nThanks."
    }
    
    @IBAction func termsConditionsPressed(_ sender: Any) {
        if let url = URL(string: "https://topcoin.network/termsofuse") {
            let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    
}

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIApplication {
    
    class var topViewController: UIViewController? {
        return getTopViewController()
    }
    
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension Equatable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
