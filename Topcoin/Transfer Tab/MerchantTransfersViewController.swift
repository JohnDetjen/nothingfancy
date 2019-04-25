//
//  MerchantTransfersViewController.swift
//  Topcoin
//
//  Created by John Detjen on 2/19/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit
import SafariServices

class MerchantTransfersViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButtonTop: NSLayoutConstraint!
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var backButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmSendLabel: UILabel!
    @IBOutlet weak var confirmSendTop: NSLayoutConstraint!
    @IBOutlet weak var confirmSendButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var confirmSendButton: UIButton!
    @IBOutlet weak var confirmSendButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmSendButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var sendAmountTop: NSLayoutConstraint!
    @IBOutlet weak var sendAmount: UITextField!
    @IBOutlet weak var topcoinLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var sendAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinLabel: UILabel!
    @IBOutlet weak var recipientlabelTop: NSLayoutConstraint!
    @IBOutlet weak var recipientLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var recipientTextHeight: NSLayoutConstraint!
    @IBOutlet weak var recipientTextLabel: UILabel!
    @IBOutlet weak var recipient: UILabel!
    @IBOutlet weak var recipientLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var recipientIconLeading: NSLayoutConstraint!
    @IBOutlet weak var recipientIcon: UIImageView!
    @IBOutlet weak var recipientIconHeight: NSLayoutConstraint!
    @IBOutlet weak var recipientIconTrailing: NSLayoutConstraint!
    @IBOutlet weak var byClickingLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var byClickingLabel: UILabel!
    @IBOutlet weak var byClickingLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var termsConditionsTop: NSLayoutConstraint!
    @IBOutlet weak var termsConditions: UIButton!
    @IBOutlet weak var termsConditionsBottom: NSLayoutConstraint!
    
    
    var sendAmountText = String()
    var recipientText = String()
    var recipientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            backButtonTop.constant = 80
            backButtonLeading.constant = 60
            backButtonHeight.constant = 80
            confirmSendLabel.font = UIFont(name: "Arial", size: 40)
            sendAmountTop.constant = 80
            sendAmount.font = UIFont(name: "Arial", size: 150)
            sendAmountHeight.constant = 130
            topcoinLabel.font = UIFont(name: "Nunito", size: 130)
            topcoinLabelHeight.constant = 130
            recipientlabelTop.constant = 50
            recipientLabelLeading.constant = 100
            recipientTextLabel.font = UIFont(name: "Arial", size: 40)
            recipientTextHeight.constant = 40
            recipientLabelBottom.constant = 50
            recipientIconLeading.constant = 100
            recipientIconHeight.constant = 80
            recipientIconTrailing.constant = 50
            recipient.font = UIFont(name: "Nunito", size: 60)
            byClickingLabelLeading.constant = 100
            byClickingLabel.font = UIFont(name: "Arial", size: 20)
            byClickingLabelTrailing.constant = 100
            confirmSendTop.constant = 40
            confirmSendButtonLeading.constant = 100
            confirmSendButtonHeight.constant = 90
            confirmSendButton.titleLabel?.font = UIFont(name: "Arial", size: 30)
            confirmSendButtonTrailing.constant = 100
            termsConditionsTop.constant = 40
            termsConditions.titleLabel?.font = UIFont(name: "Arial", size: 25)
            termsConditionsBottom.constant = 40
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
        
        sendAmount.text = sendAmountText
        recipient.text = recipientText
        recipientIcon.image = recipientImage
        
        recipientIcon.layer.cornerRadius = 0.5 * recipientIconHeight.constant
        recipientIcon.clipsToBounds = true
        
        confirmSendButton.layer.cornerRadius = 0.5 * confirmSendButtonHeight.constant
        confirmSendButton.clipsToBounds = true
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

    @IBAction func termsConditionsButtonPressed(_ sender: Any) {
        if let url = URL(string: "https://topcoin.network/termsofuse") {
            let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func send(to_email: String, amount: String, callback: @escaping () -> Void, errorCallback: @escaping (String) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/wallets/default/send")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        let parameters: [String: String] = [
            "amount": amount,
            "toUserEmail": to_email,
            "note": "Mobile transfer"
        ]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                print(String(data:data!,encoding: .utf8))
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ApiSuccessDTO.self, from: data!)
                if let status = responseModel.status {
                    if status == "success" {
                        DispatchQueue.main.async {
                            callback()
                        }
                        return
                    }
                }
            } catch { }
            do {
                let jsonDecoder = JSONDecoder()
                let errorModel = try jsonDecoder.decode(ApiErrorDTO.self, from: data!)
                if let message = errorModel.message {
                    DispatchQueue.main.async {
                        errorCallback(message)
                    }
                    return
                }
            } catch { }
            DispatchQueue.main.async {
                errorCallback("An unknown error occurred.")
            }
            print("JSON Serialization error")
        }).resume()
    }
    
    func loadAssets() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        print("confirmed!")
        guard let recipientEmail = UserDefaults.standard.string(forKey: "recipientEmail") else { return }
        confirmSendButton.isEnabled = false
        self.send(to_email: recipientEmail, amount: sendAmountText, callback: {
            self.loadAssets()
            self.confirmSendButton.isEnabled = true
        }, errorCallback: { error in
            self.confirmSendButton.isEnabled = true
            let alert = UIAlertController(title: "Unable to Send", message: error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        })
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
