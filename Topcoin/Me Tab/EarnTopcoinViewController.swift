//
//  EarnTopcoinViewController.swift
//  Topcoin
//
//  Created by John Detjen on 1/21/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit
import Parse

class EarnTopcoinViewController: UIViewController, UITextFieldDelegate {
    
    var mainViewController:AssetsViewController?

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var textCountry: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameMessage: UILabel!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var EarnTopcoinButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameMessage.isHidden = true
        
        
        textName.delegate = self
        textPhoneNumber.delegate = self
        textCountry.delegate = self
        
        doneButton.layer.cornerRadius = 25.0
        doneButton.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        switch textField {
        case textName:
            textPhoneNumber.becomeFirstResponder()
        case textPhoneNumber:
            textCountry.becomeFirstResponder()
        default:
            textCountry.resignFirstResponder()
        }
        return true
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
    
    
    
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        guard let textname = textName.text, textName.text?.characters.count != 0
            
            else {
            nameMessage.isHidden = false
            nameMessage.text = "Please enter your name"
            return
            }
        guard let phonenumber = textPhoneNumber.text, textPhoneNumber.text?.characters.count != 0
            
            else {
                nameMessage.isHidden = false
                nameMessage.text = "Please enter your phone number"
                return
        }
        
        guard let country = textCountry.text, textCountry.text?.characters.count != 0
            
            else {
                nameMessage.isHidden = false
                nameMessage.text = "Please enter your country"
                return
        }
        
        if let textname = textName.text {
            PFUser.current()?.setValue(textname, forKey: "name")
        }
        if let phonenumber = textPhoneNumber.text {
            PFUser.current()?.setValue(phonenumber, forKey: "phoneNumber")
        }
        if let country = textCountry.text {
            PFUser.current()?.setValue(country, forKey: "country")
        }
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if success {
            }
        })
        

        UserDefaults.standard.set(1, forKey: "earnedTopcoin")
        UserDefaults.standard.synchronize()

        self.loadHomeScreen()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.range(of: emailRegEx, options:.regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func loadHomeScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(vc, animated: false, completion: nil)
    }
}
