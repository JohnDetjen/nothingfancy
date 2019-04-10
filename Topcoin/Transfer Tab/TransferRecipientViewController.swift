//
//  TransferRecipientViewController.swift
//  Topcoin
//
//  Created by John Detjen on 2/3/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit
import SafariServices

class TransferRecipientViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var backButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldTop: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTextFieldTrailing: NSLayoutConstraint!
    @IBOutlet weak var enterAnEmailLabelTop: NSLayoutConstraint!
    @IBOutlet weak var enterAnEmailLabel: UILabel!
    @IBOutlet weak var sendAmount: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var toLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var toLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var merchantViewTop: NSLayoutConstraint!
    @IBOutlet weak var merchantsLeading: NSLayoutConstraint!
    @IBOutlet weak var merchantsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    var sendAmountText = String()
    var recipientText = String()
    var recipientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            backButtonTop.constant = 80
            backButtonLeading.constant = 60
            backButtonHeight.constant = 80
            sendAmount.font = UIFont(name: "Arial", size: 50)
            nextButton.titleLabel?.font = UIFont(name: "Arial", size: 40)
            nextButtonTrailing.constant = 60
            emailTextFieldTop.constant = 60
            emailTextFieldHeight.constant = 80
            emailTextFieldTrailing.constant = 70
            emailTextField.font = UIFont(name: "Arial", size: 35)
            toLabelLeading.constant = 80
            toLabelHeight.constant = 35
            toLabel.font = UIFont(name: "Arial", size: 35)
            enterAnEmailLabelTop.constant = 40
            enterAnEmailLabel.font = UIFont(name: "Arial", size: 25)
            merchantViewTop.constant = 60
            merchantsLeading.constant = 90
            merchantsLabel.font = UIFont(name: "Arial", size: 30)
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            
        }
        
        //iPad Air, 5th Gen, 6th Gen
        if view.frame.width == 768 {
            
        }
        
        //        //iphone 5
        if view.frame.width == 320 {
            
        }
        
        //tableview row height
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            self.tableView.rowHeight = 130.0
        }
        else {
            self.tableView.rowHeight = 90.0
        }
        
        sendAmount.text = sendAmountText

        //tap screen to remove keyboard
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sendAmount.becomeFirstResponder()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }

    
    override func prepare (for segue: UIStoryboardSegue, sender: Any!) {
        let svc = segue.destination as! MerchantTransfersViewController
        svc.sendAmountText = sendAmount.text!
        if (segue.identifier == "email") {
            svc.recipientText = emailTextField.text!
            svc.recipientImage = UIImage(named: "userIcon")!
        }
        if (segue.identifier == "domainOutlet") {
            svc.recipientText = "Domain Outlet"
            svc.recipientImage = UIImage(named: "domainOutlet")!
        }
        if (segue.identifier == "emojiNames") {
            svc.recipientText = "Emoji Domain Names"
            svc.recipientImage = UIImage(named: "emojiNames")!
        }
        if (segue.identifier == "nameJelly") {
            svc.recipientText = "Name Jelly"
            svc.recipientImage = UIImage(named: "nameJelly")!
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let validLogin = isValidEmail(testStr: emailTextField.text!)
        if validLogin {
            print("User entered valid input")
            UserDefaults.standard.set(emailTextField.text!, forKey: "recipientEmail")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "email", sender: self)
                        }
        } else {
            print("Invalid email address")
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address or select a merchant", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
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

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransferRecipientTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            cell.cellTextHeader.font = UIFont(name: "Arial", size: 25)
            cell.cellTextDescription.font = UIFont(name: "Arial", size: 20)
            cell.sendImageHeight.constant = 50
            cell.sendImage.layer.cornerRadius = 0.5 * cell.sendImageHeight.constant
            cell.sendImage.clipsToBounds = true
            cell.cellTextHeaderLeading.constant = 30
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 160, height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iPad Pro 10.5-inch
        if view.frame.width == 834 {
            cell.cellTextHeader.font = UIFont(name: "Arial", size: 25)
            cell.cellTextDescription.font = UIFont(name: "Arial", size: 20)
            cell.sendImageHeight.constant = 50
            cell.sendImage.layer.cornerRadius = 0.5 * cell.sendImageHeight.constant
            cell.sendImage.clipsToBounds = true
            cell.cellTextHeaderLeading.constant = 30
            
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
            cell.cellTextHeader.font = UIFont(name: "Arial", size: 25)
            cell.cellTextDescription.font = UIFont(name: "Arial", size: 20)
            cell.sendImageHeight.constant = 50
            cell.sendImage.layer.cornerRadius = 0.5 * cell.sendImageHeight.constant
            cell.sendImage.clipsToBounds = true
            cell.cellTextHeaderLeading.constant = 30
            
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
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.view.frame.size.width - (40), height: self.tableView.rowHeight - 20))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.0
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
            
        }
        
        //iphone 5
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
                    cell.sendImage.image = UIImage(named: "domainOutlet")
                    cell.cellTextHeader.text = "Domain Outlet"
                    cell.cellTextDescription.text = "domainoutlet.com"
            
        case (0,1):
        
                    cell.sendImage.image = UIImage(named: "emojiNames")
                    cell.cellTextHeader.text = "Emoji Domain Names"
                    cell.cellTextDescription.text = "emojidomainnames.com"
            
        case (0,2):
            
                    cell.sendImage.image = UIImage(named: "nameJelly")
                    cell.cellTextHeader.text = "Name Jelly"
                    cell.cellTextDescription.text = "namejelly.com"
            
        default : break
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.set("topcoin@domainoutlet.com", forKey: "recipientEmail")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "domainOutlet", sender: self)
            }
        }
        if indexPath.row == 1 {
            UserDefaults.standard.set("topcoin@domainoutlet.com", forKey: "recipientEmail")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "emojiNames", sender: self)
            }
        }
        if indexPath.row == 2 {
            UserDefaults.standard.set("topcoin@domainoutlet.com", forKey: "recipientEmail")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "nameJelly", sender: self)
            }
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
