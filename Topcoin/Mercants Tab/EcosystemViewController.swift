//
//  EcosystemViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/19/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import SafariServices

class EcosystemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var merchantLeading: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var applyButtonTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            tokensDistributedLabel.font = UIFont(name: "Arial", size: 50)
            tokenCountLabel.font = UIFont(name: "Arial", size: 40)
            walletHoldersLabel.font = UIFont(name: "Arial", size: 50)
            walletCountLabel.font = UIFont(name: "Arial", size: 40)
            walletHoldersTop.constant = 50
            tokensDistributedLeading.constant = 70
            tokensDistributedTop.constant = 70
            applyButtonHeight.constant = 80
            applyButtonLeading.constant = 100
            applyButtonTrailing.constant = 100
            applyButtonBottom.constant = 30
            applyButtonTop.constant = 30
            applyButton.titleLabel?.font = UIFont(name: "Arial", size: 30)
            merchantLabel.font = UIFont(name: "Arial", size: 30)
            merchantLeading.constant = 15
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15

        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            tokensDistributedLabel.font = UIFont(name: "Arial", size: 40)
            tokenCountLabel.font = UIFont(name: "Arial", size: 30)
            walletHoldersLabel.font = UIFont(name: "Arial", size: 40)
            walletCountLabel.font = UIFont(name: "Arial", size: 30)
            walletHoldersTop.constant = 40
            tokensDistributedLeading.constant = 70
            tokensDistributedTop.constant = 70
            applyButtonHeight.constant = 70
            applyButtonLeading.constant = 100
            applyButtonTrailing.constant = 100
            applyButtonBottom.constant = 30
            applyButtonTop.constant = 30
            applyButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
            merchantLabel.font = UIFont(name: "Arial", size: 30)
            merchantLeading.constant = 15
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15
            
        }
        
        //iPad Air, 5th Gen, 6th Gen
        if view.frame.width == 768 {
            tokensDistributedLabel.font = UIFont(name: "Arial", size: 40)
            tokenCountLabel.font = UIFont(name: "Arial", size: 30)
            walletHoldersLabel.font = UIFont(name: "Arial", size: 40)
            walletCountLabel.font = UIFont(name: "Arial", size: 30)
            walletHoldersTop.constant = 40
            tokensDistributedLeading.constant = 70
            tokensDistributedTop.constant = 70
            applyButtonHeight.constant = 70
            applyButtonLeading.constant = 100
            applyButtonTrailing.constant = 100
            applyButtonBottom.constant = 30
            applyButtonTop.constant = 30
            applyButton.titleLabel?.font = UIFont(name: "Arial", size: 25)
            merchantLabel.font = UIFont(name: "Arial", size: 30)
            merchantLeading.constant = 15
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15
        }
        
        //        //iphone 5
        //        if view.frame.width == 320 {
        //        }

        applyButton.layer.cornerRadius = 5
        applyButton.clipsToBounds = true
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            self.tableView.rowHeight = 130.0
        }
        else {
            self.tableView.rowHeight = 90.0
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EcosystemTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            cell.merchantLabel.font = UIFont(name: "Arial", size: 25)
            cell.merchantDescription.font = UIFont(name: "Arial", size: 20)
            cell.merchantImageHeight.constant = 60
            cell.merchantImage.layer.cornerRadius = 0.5 * cell.merchantImageHeight.constant
            cell.merchantImage.clipsToBounds = true
            cell.merchantLabelLeading.constant = 30
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 160, height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            cell.merchantLabel.font = UIFont(name: "Arial", size: 25)
            cell.merchantDescription.font = UIFont(name: "Arial", size: 20)
            cell.merchantImageHeight.constant = 60
            cell.merchantImage.layer.cornerRadius = 0.5 * cell.merchantImageHeight.constant
            cell.merchantImage.clipsToBounds = true
            cell.merchantLabelLeading.constant = 30
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 160, height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iPad Air, 5th Gen, 6th Gen
        if view.frame.width == 768 {
            cell.merchantLabel.font = UIFont(name: "Arial", size: 25)
            cell.merchantDescription.font = UIFont(name: "Arial", size: 20)
            cell.merchantImageHeight.constant = 60
            cell.merchantImage.layer.cornerRadius = 0.5 * cell.merchantImageHeight.constant
            cell.merchantImage.clipsToBounds = true
            cell.merchantLabelLeading.constant = 30
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 160, height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iPhone 6+, 6s+, 7+, 8+, Xs Max, Xr
        if view.frame.width == 414 {
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.view.frame.size.width - (40), height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iPhone X, Xs, 6, 6s, 7, 8
        if view.frame.width == 375 {
            
//            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.view.frame.size.width - (40), height: self.tableView.rowHeight - 20))
//            
//            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
//            whiteRoundedView.layer.masksToBounds = false
//            whiteRoundedView.layer.cornerRadius = 5
//            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
//            whiteRoundedView.layer.shadowOpacity = 0.0
//            
//            cell.contentView.addSubview(whiteRoundedView)
//            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iphone 5, 5s, SE
        if view.frame.width == 320 {
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.view.frame.size.width - (40), height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
        }
        

        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0):
            cell.merchantImage.image = UIImage(named: "domainOutlet")
            cell.merchantLabel.text = "Domain Outlet"
            cell.merchantDescription.text = "domainoutlet.com"
            
        case (0,1):
            
            cell.merchantImage.image = UIImage(named: "emojiNames")
            cell.merchantLabel.text = "Emoji Domain Names"
            cell.merchantDescription.text = "emojidomainnames.com"
            
        case (0,2):
            
            cell.merchantImage.image = UIImage(named: "nameJelly")
            cell.merchantLabel.text = "Name Jelly"
            cell.merchantDescription.text = "namejelly.com"
            
        default : break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let url = URL(string: "http://domainoutlet.com") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        if indexPath.row == 1 {
            if let url = URL(string: "https://emojidomainnames.com") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        if indexPath.row == 2 {
            if let url = URL(string: "http://namejelly.com") {
                let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                self.present(svc, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}
