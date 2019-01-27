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

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.layer.cornerRadius = 25.0
        logOutButton.clipsToBounds = true

    }

    override func viewWillAppear(_ animated: Bool) {
        let username = UserDefaults.standard.string(forKey: "email")
        if(username != nil) {
            self.userLabel.text = username
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,1):
            
            if let url = URL(string: "http://topcoin.com") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            
            
        case (0,2):
            
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

    @IBAction func logOutButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "balance")
//        UserDefaults.standard.removeObject(forKey: "earnedTopcoin")
        self.loadLoginScreen()
    }
    
    func loadLoginScreen(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
//        self.present(viewController, animated: true, completion: nil)
        if let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeViewController {
            let loginNavigation = UINavigationController(rootViewController: welcomeVC)
            self.present(loginNavigation, animated: true, completion: nil)
    }
    
}

}
