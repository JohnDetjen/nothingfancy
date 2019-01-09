//
//  MeViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/10/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import SafariServices

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let cellSpacingHeight: CGFloat = 15
    let cellSpacingHeightNone: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addReusableViewController()
        logOut.layer.cornerRadius = 25.0
        logOut.clipsToBounds = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0) {
            return cellSpacingHeightNone
        }
        else {
           return cellSpacingHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MeTableViewCell
        
        switch (indexPath.section, indexPath.row) {
            
            
        case (0,0):
            cell.label.text = "Project Promotion"
            cell.meImage.image = UIImage(named: "topcoinIcon")
        
        case (0,1):
            cell.label.text = "About"
            cell.meImage.image = UIImage(named: "aboutIcon")
            
            
        default : break
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
//        case (0,0):
//
//            // Safe Push VC
//            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "manageWalletVC") as? ManageWalletTableViewController {
//                if let navigator = navigationController {
//                    navigator.pushViewController(viewController, animated: true)
//                }
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
        
        case (0,0):
            
            if let url = URL(string: "http://topcoin.com") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            
            
        case (0,1):
            
            // Safe Push VC
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutTableViewController") as? AboutTableViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        default : break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if section == 0 {
            rowCount = 2
        }
//        if section == 1 {
//            rowCount = 1
//        }
//        if section == 2 {
//            rowCount = 1
//        }
        return rowCount
    }
    
    @IBAction func logOutbuttonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "email")
        self.loadLoginScreen()
        
    }
    
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.present(viewController, animated: true, completion: nil)
    }
    

}
