//
//  ManageWalletTableViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/12/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import Parse
import SafariServices

class ManageWalletTableViewController: UITableViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logOutButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var topcoinLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinLogoTop: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinWalletLabel: UILabel!
    @IBOutlet weak var topcoinWalletBottom: NSLayoutConstraint!
    @IBOutlet weak var termsConditions: UIButton!
    @IBOutlet weak var walletIconLeading: NSLayoutConstraint!
    @IBOutlet weak var walletIconHeight: NSLayoutConstraint!
    @IBOutlet weak var walletLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var aboutIconLeading: NSLayoutConstraint!
    @IBOutlet weak var aboutIconHeight: NSLayoutConstraint!
    @IBOutlet weak var aboutLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var shareIconLeading: NSLayoutConstraint!
    @IBOutlet weak var shareIconHeight: NSLayoutConstraint!
    @IBOutlet weak var shareLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var earnTopcoinIconLeading: NSLayoutConstraint!
    @IBOutlet weak var earnTopcoinIconHeight: NSLayoutConstraint!
    @IBOutlet weak var earnTopcoinLeading: NSLayoutConstraint!
    @IBOutlet weak var earnTopcoinLabel: UILabel!
    @IBOutlet weak var logOutButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var logOutButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var termsConditionsTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            view1.frame.size.height = 350
            view2.frame.size.height = 350
            topcoinLogoTop.constant = 80
            topcoinLogoHeight.constant = 100
            topcoinWalletLabelHeight.constant = 100
            topcoinWalletLabel.font = UIFont(name: "Arial", size: 40)
            topcoinWalletBottom.constant = 50
            walletIconLeading.constant = 70
            walletIconHeight.constant = 30
            walletLabelLeading.constant = 40
            walletLabel.font = UIFont(name: "Arial", size: 25)
            aboutIconLeading.constant = 70
            aboutIconHeight.constant = 30
            aboutLabelLeading.constant = 40
            aboutLabel.font = UIFont(name: "Arial", size: 25)
            shareIconLeading.constant = 70
            shareIconHeight.constant = 30
            shareLabelLeading.constant = 40
            shareLabel.font = UIFont(name: "Arial", size: 25)
            earnTopcoinIconLeading.constant = 70
            earnTopcoinIconHeight.constant = 30
            earnTopcoinLeading.constant = 40
            earnTopcoinLabel.font = UIFont(name: "Arial", size: 25)
            logOutButtonLeading.constant = 100
            logOutButtonHeight.constant = 90
            logOutButton.titleLabel?.font = UIFont(name: "Arial", size: 30)
            logOutButtonTrailing.constant = 100
            termsConditionsTop.constant = 25
            termsConditions.titleLabel?.font = UIFont(name: "Arial", size: 25)
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            view1.frame.size.height = 250
            view2.frame.size.height = 250
            topcoinLogoTop.constant = 60
            topcoinLogoHeight.constant = 80
            topcoinWalletLabelHeight.constant = 100
            topcoinWalletLabel.font = UIFont(name: "Arial", size: 35)
            topcoinWalletBottom.constant = 50
            walletIconLeading.constant = 70
            walletIconHeight.constant = 30
            walletLabelLeading.constant = 40
            walletLabel.font = UIFont(name: "Arial", size: 20)
            aboutIconLeading.constant = 70
            aboutIconHeight.constant = 30
            aboutLabelLeading.constant = 40
            aboutLabel.font = UIFont(name: "Arial", size: 20)
            shareIconLeading.constant = 70
            shareIconHeight.constant = 30
            shareLabelLeading.constant = 40
            shareLabel.font = UIFont(name: "Arial", size: 20)
            earnTopcoinIconLeading.constant = 70
            earnTopcoinIconHeight.constant = 30
            earnTopcoinLeading.constant = 40
            earnTopcoinLabel.font = UIFont(name: "Arial", size: 20)
            logOutButtonLeading.constant = 100
            logOutButtonHeight.constant = 70
            logOutButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
            logOutButtonTrailing.constant = 100
            termsConditionsTop.constant = 20
            termsConditions.titleLabel?.font = UIFont(name: "Arial", size: 20)
        }
        
        //iPad Air, 5th Gen, 6th Gen
        if view.frame.width == 768 {
            view1.frame.size.height = 250
            view2.frame.size.height = 250
            topcoinLogoTop.constant = 60
            topcoinLogoHeight.constant = 80
            topcoinWalletLabelHeight.constant = 100
            topcoinWalletLabel.font = UIFont(name: "Arial", size: 35)
            topcoinWalletBottom.constant = 50
            walletIconLeading.constant = 70
            walletIconHeight.constant = 30
            walletLabelLeading.constant = 40
            walletLabel.font = UIFont(name: "Arial", size: 20)
            aboutIconLeading.constant = 70
            aboutIconHeight.constant = 30
            aboutLabelLeading.constant = 40
            aboutLabel.font = UIFont(name: "Arial", size: 20)
            shareIconLeading.constant = 70
            shareIconHeight.constant = 30
            shareLabelLeading.constant = 40
            shareLabel.font = UIFont(name: "Arial", size: 20)
            earnTopcoinIconLeading.constant = 70
            earnTopcoinIconHeight.constant = 30
            earnTopcoinLeading.constant = 40
            earnTopcoinLabel.font = UIFont(name: "Arial", size: 20)
            logOutButtonLeading.constant = 100
            logOutButtonHeight.constant = 70
            logOutButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
            logOutButtonTrailing.constant = 100
            termsConditionsTop.constant = 20
            termsConditions.titleLabel?.font = UIFont(name: "Arial", size: 20)
        }
        
        //iphone 5
        if view.frame.width == 320 {
            view1.frame.size.height = 140
            view2.frame.size.height = 200
            topcoinLogoTop.constant = 30
            topcoinLogoHeight.constant = 40
            topcoinWalletBottom.constant = 20
            termsConditionsTop.constant = 0
        }
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            self.tableView.rowHeight = 110.0
        }
        else {
            self.tableView.rowHeight = 50.0
        }
        
        logOutButton.layer.cornerRadius = 0.5 * logOutButtonHeight.constant
        logOutButton.clipsToBounds = true

    }

    override func viewWillAppear(_ animated: Bool) {
        let username = UserDefaults.standard.string(forKey: "email")
        if(username != nil) {
            self.userLabel.text = username
        }
        
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

    @objc func tapButton(){
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1) {
            return 3
        } else {
           return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,1):
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "aboutTableViewController")
            self.present(controller, animated: false, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            
            
        case (0,2):
            
            "Hi, I've been using Topcoin to get discounts on digital goods.\n\nSign up now and get 100 free Topcoin.\n\nClaim your invite here:\nhttp://bit.ly/topcoinrewards".share()
            tableView.deselectRow(at: indexPath, animated: true)
            
        case (0,3):
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "EarnTopcoinViewController")
            self.present(controller, animated: false, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            
        default : break
        }
    }

    @IBAction func logOutButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "balance")
//        UserDefaults.standard.removeObject(forKey: "earnedTopcoin")
        self.loadLoginScreen()
    }
    
    
    @IBAction func termsButtonPressed(_ sender: Any) {
        if let url = URL(string: "https://topcoin.network/termsofuse") {
            let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(svc, animated: false, completion: nil)
        }
    }
    
    func loadLoginScreen(){

        if let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeViewController {
            let loginNavigation = UINavigationController(rootViewController: welcomeVC)
            self.present(loginNavigation, animated: true, completion: nil)
        }
    
    }

}

