//
//  AboutTableViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/12/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var backButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinLogoTop: NSLayoutConstraint!
    @IBOutlet weak var topcoinLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletLabelTop: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletLabel2Leading: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletText: UILabel!
    @IBOutlet weak var topcoinWalletLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletLabel2Trailing: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletText2: UILabel!
    @IBOutlet weak var topcoinWalletLabel2Height: NSLayoutConstraint!
    @IBOutlet weak var userServiceLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var userServiceLabel: UILabel!
    @IBOutlet weak var contactUsLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var copyrightBottom: NSLayoutConstraint!
    @IBOutlet weak var allRightsReservedLabel: UILabel!
    @IBOutlet weak var allRightsReservedBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            view1.frame.size.height = 550
            view2.frame.size.height = 350
            backButtonTop.constant = 80
            backButtonLeading.constant = 60
            backButtonHeight.constant = 80
            topcoinLogoTop.constant = 80
            topcoinLogoHeight.constant = 100
            topcoinWalletLabelTop.constant = 40
            topcoinWalletLabelHeight.constant = 40
            topcoinWalletText.font = UIFont(name: "Arial", size: 30)
            topcoinWalletLabelBottom.constant = 20
            topcoinWalletLabel2Leading.constant = 120
            topcoinWalletText2.font = UIFont(name: "Arial", size: 30)
            topcoinWalletLabel2Height.constant = 100
            topcoinWalletLabel2Trailing.constant = 120
            userServiceLabelLeading.constant = 70
            userServiceLabel.font = UIFont(name: "Arial", size: 30)
            contactUsLabelLeading.constant = 70
            contactUsLabel.font = UIFont(name: "Arial", size: 30)
            supportLabel.font = UIFont(name: "Arial", size: 30)
            copyrightLabel.font = UIFont(name: "Arial", size: 25)
            copyrightBottom.constant = 150
            allRightsReservedLabel.font = UIFont(name: "Arial", size: 25)
            allRightsReservedBottom.constant = 10
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
        
        }
        
        //iPad Air, 5th Gen, 6th Gen
        if view.frame.width == 768 {

        }
        
        //        //iphone 5
        //        if view.frame.width == 320 {
        //        }

        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            self.tableView.rowHeight = 110.0
        }
        else {
            self.tableView.rowHeight = 50.0
        }

    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            
            if let url = URL(string: "https://topcoin.network/termsofuse") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        case (0,1):
            
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
        default : break
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@topcoin.network"])
        mailComposerVC.setSubject("Support")
        mailComposerVC.setMessageBody("", isHTML: false)
        
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

}
