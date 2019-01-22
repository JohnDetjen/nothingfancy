//
//  LogInViewController.swift
//  Topcoin
//
//  Created by John Detjen on 1/1/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

struct ApiSuccessDTO : Codable {
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct ApiErrorDTO : Codable {
    let error : Int?
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        error = try values.decodeIfPresent(Int.self, forKey: .error)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        textEmail.delegate = self

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
    
    func textFieldShouldReturn(_ textEmail: UITextField) -> Bool {
        self.view.endEditing(true)
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
    
//    func apiSignup(email: String, password: String, name: String, callback: @escaping () -> Void, error errorCallback: @escaping (String) -> Void) {
//        let escapedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let escapedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let escapedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let body = "grant_type=password&email=\(escapedEmail)&username=\(escapedEmail)&password=\(escapedPassword)&firstName=\(escapedName)&lastName=User"
//
//        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/users")!)
//        request.httpMethod = "POST"
//        request.httpBody = body.data(using: .utf8)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//    request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
//
//        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
//            do {
//                let jsonDecoder = JSONDecoder()
//                let successModel = try jsonDecoder.decode(ApiSuccessDTO.self, from: data!)
//                if successModel.status == "success" {
//                    DispatchQueue.main.async {
//                        callback()
//                    }
//                    return
//                }
//            } catch { }
//            do {
//                let jsonDecoder = JSONDecoder()
//                let errorModel = try jsonDecoder.decode(ApiErrorDTO.self, from: data!)
//                if let message = errorModel.message {
//                    DispatchQueue.main.async {
//                        errorCallback(message)
//                    }
//                    return
//                }
//            } catch { }
//            DispatchQueue.main.async {
//                errorCallback("An unknown error occurred.")
//            }
//        }).resume()
//    }
    
    func apiSignup(email: String, callback: @escaping () -> Void, error errorCallback: @escaping (String) -> Void) {
        let escapedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let escapedPassword = password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let escapedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = "grant_type=password&email=\(escapedEmail)&username="
//        \(escapedEmail)&password=\(escapedPassword)&firstName=\(escapedName)&lastName=User"
//        let body = "grant_type=password&email=\(escapedEmail)&username=\(escapedEmail)&password=\(escapedPassword)&firstName=\(escapedName)&lastName=User"
        
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/users")!)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let successModel = try jsonDecoder.decode(ApiSuccessDTO.self, from: data!)
                if successModel.status == "success" {
                    DispatchQueue.main.async {
                        callback()
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

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        apiSignup(email: textEmail.text ?? "", callback: {
//             apiSignup(email: textEmail.text ?? "", password: textPassword.text ?? "", name: textName.text ?? "", callback: {
//            UserDefaults.standard.set(self.textEmail.text, forKey: "email")
//            self.navigationController?.dismiss(animated: true, completion: nil)
            self.loadCheckEmailScreen()
        }, error: { message in
            let alert = UIAlertController(title: "Sign Up Failed", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func loadHomeScreen() {
        if let AssetsViewController = storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as? AssetsViewController {
            let homeNavigation = UINavigationController(rootViewController: AssetsViewController)
            self.present(homeNavigation, animated: true, completion: nil)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadCheckEmailScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CheckEmailViewController") as! CheckEmailViewController
        self.present(newViewController, animated: false, completion: nil)
    }
}
