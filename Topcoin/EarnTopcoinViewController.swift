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

    @IBOutlet weak var containerView: UIView!
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
        addReusableViewController()
        
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
        addReusableViewController()
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
    
    func addReusableViewController() {
        guard let vc = ReusableViewController.getInstance(storyboard: storyboard) else { return }
        //        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ReusableViewController.self)) as? ReusableViewController else { return }
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
    
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
    
    func loadHomeScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(vc, animated: false, completion: nil)
    }
}
