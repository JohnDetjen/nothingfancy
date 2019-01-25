//
//  ApplyViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/12/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import Parse

class ApplyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var yourNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var yourMessageTextField: UITextField!
    @IBOutlet weak var submitMessage: UIButton!
    @IBOutlet weak var nameMessage: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        yourNameTextField.delegate = self
        emailAddressTextField.delegate = self
        phoneNumberTextField.delegate = self
        countryTextField.delegate = self
        
        nameMessage.isHidden = true
        
        submitMessage.layer.cornerRadius = 25.0
        submitMessage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        addReusableViewController()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        switch textField {
        case yourNameTextField:
            phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            emailAddressTextField.becomeFirstResponder()
        case emailAddressTextField:
            countryTextField.becomeFirstResponder()
        default:
            countryTextField.resignFirstResponder()
        }

        return true
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
    
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        
        guard let textname = yourNameTextField.text, yourNameTextField.text?.characters.count != 0
            
            else {
                nameMessage.isHidden = false
                nameMessage.text = "Please enter company name"
                return
        }
        guard let phonenumber = phoneNumberTextField.text, phoneNumberTextField.text?.characters.count != 0
            
            else {
                nameMessage.isHidden = false
                nameMessage.text = "Please enter company phone number"
                return
        }
        
        guard let address = emailAddressTextField.text, emailAddressTextField.text?.characters.count != 0
            
            else {
                nameMessage.isHidden = false
                nameMessage.text = "Please enter company address"
                return
        }
        
        guard let country = countryTextField.text, countryTextField.text?.characters.count != 0
            
            else {
                nameMessage.isHidden = false
                nameMessage.text = "Please enter company country"
                return
        }
        
        if let textname = yourNameTextField.text {
            PFUser.current()?.setValue(textname, forKey: "companyName")
        }
        if let phonenumber = phoneNumberTextField.text {
            PFUser.current()?.setValue(phonenumber, forKey: "companyPhoneNumber")
        }
        if let address = emailAddressTextField.text {
            PFUser.current()?.setValue(address, forKey: "companyAddress")
        }
        if let country = countryTextField.text {
            PFUser.current()?.setValue(country, forKey: "companyCountry")
        }
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if success {
            }
        })
        
        
        self.loadHomeScreen()
    }
    
    
    func loadHomeScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(vc, animated: false, completion: nil)
    }
    

}
