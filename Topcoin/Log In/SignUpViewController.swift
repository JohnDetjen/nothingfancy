//
//  SignUpViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/26/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import MBProgressHUD

struct ApiLoginDTO : Codable {
    let access_token : String?
    
    enum CodingKeys: String, CodingKey {
        case access_token = "access_token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        access_token = try values.decodeIfPresent(String.self, forKey: .access_token)
    }
}

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        textEmail.delegate = self
        textPassword.delegate = self
        
        addReusableViewController()
        
        doneButton.layer.cornerRadius = 25.0
        doneButton.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        swipeToPop()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addReusableViewController()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textEmail: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func alert(message: NSString, title: NSString) {
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
    
    func swipeToPop() {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //reusable controller background view
    func addReusableViewController() {
        guard let vc = ReusableViewController.getInstance(storyboard: storyboard) else { return }
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
        performSegueToReturnBack()
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        apiLogin(email: textEmail.text ?? "", password: textPassword.text ?? "", callback: { token in
            UserDefaults.standard.set(self.textEmail.text, forKey: "email")
            UserDefaults.standard.set(token, forKey: "token")
//
            self.loadHomeScreen()
            
        }, error: { message in
            let alert = UIAlertController(title: "Log In Failed", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    func apiLogin(email: String, password: String, callback: @escaping (String) -> Void, error errorCallback: @escaping (String) -> Void) {
        let escapedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = "grant_type=password&username=\(escapedEmail)&password=\(escapedPassword)"
        
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/auth/token/")!)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let loginModel = try jsonDecoder.decode(ApiLoginDTO.self, from: data!)
                if let accessToken = loginModel.access_token {
                    DispatchQueue.main.async {
                        callback(accessToken)
                    }
                    return
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
        }).resume()
    }
    
    func apiForgotPassword(email: String, callback: @escaping () -> Void, error errorCallback: @escaping (String) -> Void) {
        let escapedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = "grant_type=password&email=\(escapedEmail)"
        
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/auth/forgotPassword/")!)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(String(data: data!, encoding: .utf8))
            do {
                let jsonDecoder = JSONDecoder()
                let errorModel = try jsonDecoder.decode(ApiErrorDTO.self, from: data!)
                if errorModel.error != nil {
                    if let message = errorModel.message {
                        DispatchQueue.main.async {
                            errorCallback(message)
                        }
                        return
                    }
                }
            } catch { }
            DispatchQueue.main.async {
                callback()
            }
        }).resume()
    }
    
    
    func loadHomeScreen() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
        }
}


extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: false)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
