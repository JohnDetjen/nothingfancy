//
//  MerchantsViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/6/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import SafariServices

class MerchantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.layer.borderWidth = 2.0
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 5.0
        signUpButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MerchantTableViewCell
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.merchantName.text = "UNI"
            cell.merchantImage.image = UIImage(named: "uniregistryLogo")
            
        case (0,1):
            cell.merchantName.text = "Porkbun"
            cell.merchantImage.image = UIImage(named: "porkbunLogo")
        
        default : break
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
            
            
        case 0:
                if let url = URL(string: "http://uniregistry.com") {
                    let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    self.present(svc, animated: true, completion: nil)
            }
        case 1:
            if let url = URL(string: "https://porkbun.com") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
            }
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
