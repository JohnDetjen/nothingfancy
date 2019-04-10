//
//  TransferViewController.swift
//  Topcoin
//
//  Created by John Detjen on 2/2/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var backButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var sendLabel: UIButton!
    @IBOutlet weak var sendAmountTop: NSLayoutConstraint!
    @IBOutlet weak var sendAmount: UITextField!
    @IBOutlet weak var sendAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var balanceShown: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var topcoinAvailableLeading: NSLayoutConstraint!
    @IBOutlet weak var topcoinAvailableLabel: UILabel!
    @IBOutlet weak var topcoinLabel: UILabel!
    @IBOutlet weak var topcoinLabelheight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController() //reusable controller background view
        sendAmount.delegate = self // connect sendAmount to numberpad
        sendAmount.becomeFirstResponder() //open numberpad when view appears
        
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            backButtonTop.constant = 80
            backButtonLeading.constant = 60
            backButtonHeight.constant = 80
            sendLabel.titleLabel?.font = UIFont(name: "Arial", size: 40)
            nextButton.titleLabel?.font = UIFont(name: "Arial", size: 40)
            nextButtonTrailing.constant = 60
            viewTop.constant = 40
            viewHeight.constant = 100
            balanceShown.font = UIFont(name: "Arial", size: 40)
            topcoinAvailableLeading.constant = 12
            topcoinAvailableLabel.font = UIFont(name: "Arial", size: 40)
            sendAmountTop.constant = 100
            sendAmount.font = UIFont(name: "Arial", size: 150)
            sendAmountHeight.constant = 150
            topcoinLabel.font = UIFont(name: "Nunito", size: 130)
            topcoinLabelheight.constant = 130
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
        
    //determine user balance
        if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1) {
            if UserDefaults.standard.object(forKey: "balance") != nil {
                let balance = UserDefaults.standard.double(forKey: "balance")
                self.balanceShown.text = "\(balance+100)0"
            } else {
                self.balanceShown.text = "100.00"
            }
        } else {
            if UserDefaults.standard.object(forKey: "balance") != nil {
                let balance = UserDefaults.standard.double(forKey: "balance")
                self.balanceShown.text = "\(balance)0"
            } else {
                self.balanceShown.text = "0.00"
            }
        }
        
    //load screen with disabled next button
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        
    }

    override func viewWillAppear(_ animated: Bool) {
    //open numberpad when view appears
        sendAmount.becomeFirstResponder()
    }
    
    //only allow integers in textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty && !invalidCharacters.isEmpty {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }

        return string.rangeOfCharacter(from: invalidCharacters) == nil

    }
    
    //next button segue changes sendAmount text on TransferRecipientViewController
    override func prepare (for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "nextButtonSegue") {
            let svc = segue.destination as! TransferRecipientViewController
            svc.sendAmountText = sendAmount.text!
        }
    }
    
    //next button segue to TransferRecipientViewController
    @IBAction func nextButtonPressed(_ sender: Any) {

        let sendAmountString = sendAmount.text
        var sendAmountInteger = Float(sendAmountString!)

        let balanceShownString = balanceShown.text
        var balanceShownInteger = Float(balanceShownString!)


        if let sendAmount = sendAmountInteger {
            if let balance = balanceShownInteger {
                if sendAmount > balance {
                    let alert = UIAlertController(title: "Error", message: "You do not have enough to send this amount", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                }
                if sendAmount == 0 {
                    let alert = UIAlertController(title: "Error", message: "Please enter a valid amount", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "nextButtonSegue", sender: self)
                }
            }
        }
    }
    
    //reusable controller background view
    func addReusableViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ReusableViewController.self)) as? ReusableViewController else { return }
        vc.willMove(toParent: self)
        addChild(vc)
        containerView.addSubview(vc.view)
        constraintViewEqual(view1: containerView, view2: vc.view)
        vc.didMove(toParent: self)
    }
    
    // Sticks child view (view1) to the parent view (view2) using constraints.
    private func constraintViewEqual(view1: UIView, view2: UIView) {
        view2.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0)
        let constraint2 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)
        let constraint3 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)
        let constraint4 = NSLayoutConstraint(item: view1, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view2, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0)
        view1.addConstraints([constraint1, constraint2, constraint3, constraint4])
    }

    //back button pressed
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
