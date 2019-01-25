//
//  AssetsViewController.swift
//  Topcoin
//
//  Created by John Detjen on 12/7/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit
import Parse
import BlockiesSwift

struct BalanceDTO : Codable {
    let old_balance : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case old_balance = "old_balance"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        old_balance = try Double(values.decodeIfPresent(String.self, forKey: .old_balance) ?? "")
    }
}

struct ApiUserDTO : Codable {
    let email : String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }
}

struct ApiVerifySuccessDTO : Codable {
    let user : ApiUserDTO?
    
    enum CodingKeys: String, CodingKey {
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(ApiUserDTO.self, forKey: .user)
    }
}

class AssetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var balanceShown: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var earnTopcoinButton: UIButton!
    @IBOutlet weak var earnTopcoinButtonHeight: NSLayoutConstraint!
    
    var loaded: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()

        self.tableView.rowHeight = 90.0
        earnTopcoinButton.layer.cornerRadius = 25.0
        earnTopcoinButton.clipsToBounds = true
        
        userImage.layer.borderWidth = 0
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = 5
//        userImage?.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        
        if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1) {
            earnTopcoinButtonHeight.constant = 0
            if UserDefaults.standard.object(forKey: "balance") != nil {
                let balance = UserDefaults.standard.double(forKey: "balance")
                self.balanceShown.text = "\(balance+100)0"
            } else {
                self.balanceShown.text = "100.00"
            }
            
        } else {
            earnTopcoinButtonHeight.constant = 50
            if UserDefaults.standard.object(forKey: "balance") != nil {
                let balance = UserDefaults.standard.double(forKey: "balance")
                self.balanceShown.text = "\(balance)0"
            } else {
                self.balanceShown.text = "0.00"
            }
        }

        reloadBalance()
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
    
    
    func reloadBalance() {
        getBalance { balance in
            if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1) {
                self.balanceShown.text = "\(balance+100)0"
            } else {
                self.balanceShown.text = "\(balance)0"
            }
            UserDefaults.standard.set(balance, forKey: "balance")
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1) {
            earnTopcoinButtonHeight.constant = 0
            if UserDefaults.standard.object(forKey: "balance") != nil {
                let balance = UserDefaults.standard.double(forKey: "balance")
                self.balanceShown.text = "\(balance+100)0"
            } else {
                self.balanceShown.text = "100.00"
            }
            
        } else {
            earnTopcoinButtonHeight.constant = 50
            if UserDefaults.standard.object(forKey: "balance") != nil {
                let balance = UserDefaults.standard.double(forKey: "balance")
                self.balanceShown.text = "\(balance)0"
            } else {
                self.balanceShown.text = "0.00"
            }
        }
        
        reloadBalance()
    }

    
    func loadLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            if let id = UserDefaults.standard.string(forKey: "id") {
                if UserDefaults.standard.string(forKey: "email") == nil {
                    apiVerify(id: id, token: token, callback: { email, token in
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(id, forKey: "id")
                        self.reloadBalance()
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
    
    func getBalance(callback: @escaping (Double) -> Void) {
        print("get balance")
        guard let email = UserDefaults.standard.string(forKey: "email")?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/public/accountBalance/\(email)")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                print(String(data:data!,encoding: .utf8))
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(BalanceDTO.self, from: data!)
                if let balance = responseModel.old_balance {
                    DispatchQueue.main.async {
                        callback(balance)
                    }
                }
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func onUserAction(data: String)
    {
        print("Data received: \(data)")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssetsTableViewCell
        
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.view.frame.size.width - 40, height: 75))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        switch (indexPath.section, indexPath.row) {
            
        case (0,0):
            if(UserDefaults.standard.object(forKey: "balance") == nil){
                if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1){
                    cell.balanceLabel.text = "100.00"
                    cell.sendImage.image = UIImage(named: "downArrow")
                    cell.cellTextHeader.text = "Received"
                    cell.cellTextDescription.text = "from Topcoin"
                }else{
                    cell.balanceLabel.text = ""
                    cell.sendImage.image = UIImage(named: "topcoinLogoDarkSmall")
                    cell.cellTextHeader.text = "No transactions yet"
                    cell.cellTextDescription.text = "Transaction details here"
                }
            }else{
                if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1){
                    cell.balanceLabel.text = "100.00"
                    cell.sendImage.image = UIImage(named: "downArrow")
                    cell.cellTextHeader.text = "Received"
                    cell.cellTextDescription.text = "from Topcoin"
                }else{
                    let balance = UserDefaults.standard.double(forKey: "balance")
                    cell.balanceLabel.text = "\(balance)0"
                    cell.sendImage.image = UIImage(named: "downArrow")
                    cell.cellTextHeader.text = "Received"
                    cell.cellTextDescription.text = "from Uniregistry"
                }
            }
            
        case (0,1):
            if(UserDefaults.standard.object(forKey: "balance") == nil){
                cell.isHidden = true
            }else{
                if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1){
                    let balance = UserDefaults.standard.double(forKey: "balance")
                    cell.balanceLabel.text = "\(balance)0"
                    cell.sendImage.image = UIImage(named: "downArrow")
                    cell.cellTextHeader.text = "Received"
                    cell.cellTextDescription.text = "from Uniregistry"
                }else{
                    cell.isHidden = true
                }
            }
        default : break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let hasBalanace = UserDefaults.standard.object(forKey: "balance") != nil
        return hasBalanace ? 2 : 2
    }
    
    func loadHomeScreen() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }

}


