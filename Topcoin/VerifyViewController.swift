//
//  VerifyViewController.swift
//  Topcoin
//
//  Created by John Detjen on 1/16/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    func loadLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func loadAssets() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func apiVerify(id: String, token: String, callback: @escaping (String, String) -> Void, error errorCallback: @escaping (String) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/users/\(id)")!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let verifySuccessModel = try jsonDecoder.decode(ApiVerifySuccessDTO.self, from: data)
                    if let email = verifySuccessModel.user?.email {
                        DispatchQueue.main.async {
                            callback(email, token)
                        }
                        return
                    }
                } catch { }
                do {
                    let jsonDecoder = JSONDecoder()
                    let errorModel = try jsonDecoder.decode(ApiErrorDTO.self, from: data)
                    if let message = errorModel.message {
                        DispatchQueue.main.async {
                            errorCallback(message)
                        }
                        return
                    }
                } catch { }
            }
            DispatchQueue.main.async {
                errorCallback("An unknown error occurred.")
            }
        }).resume()
    }
    
    
    func success(id: String, token: String, email: String) {
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(id, forKey: "id")
        self.loadAssets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            if let id = UserDefaults.standard.string(forKey: "id") {
                if UserDefaults.standard.string(forKey: "email") == nil {
                    let start = DispatchTime.now()
                    apiVerify(id: id, token: token, callback: { email, token in
                        DispatchQueue.main.asyncAfter(deadline: start + 2, execute: {
                            self.success(id: id, token: token, email: email)
                        })
                    }, error: { message in
                        self.loadLogin()
                    })
                }
            } else {
                self.loadLogin()
            }
        } else {
            self.loadLogin()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addReusableViewController()
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
}
