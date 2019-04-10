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
    let balance : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case balance = "balance"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        balance = try Double(values.decodeIfPresent(String.self, forKey: .balance) ?? "")
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

struct Transaction {
    let from_email : String
    let to_email : String
    let amount : Double
    let token_type : String
    let entry_time : String
    let note : String
}

struct TransactionDTO : Codable {
    let from_email : String
    let to_email : String
    let amount : Double
    let token_type : String
    let entry_time : String
    let note : String
    
    enum CodingKeys: String, CodingKey {
        case from_email = "from_email"
        case to_email = "to_email"
        case amount = "amount"
        case token_type = "token_type"
        case entry_time = "entry_time"
        case note = "note"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        from_email = try values.decodeIfPresent(String.self, forKey: .from_email) ?? ""
        to_email = try values.decodeIfPresent(String.self, forKey: .to_email) ?? ""
        amount = Double(try values.decodeIfPresent(String.self, forKey: .amount) ?? "") ?? 0.0
        token_type = try values.decodeIfPresent(String.self, forKey: .token_type) ?? ""
        entry_time = try values.decodeIfPresent(String.self, forKey: .entry_time) ?? ""
        note = try values.decodeIfPresent(String.self, forKey: .note) ?? ""
    }
}

struct TransactionsDTO : Codable {
    let ledger_entries : [TransactionDTO]
    
    enum CodingKeys: String, CodingKey {
        
        case ledger_entries = "ledger_entries"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ledger_entries = try values.decodeIfPresent([TransactionDTO].self, forKey: .ledger_entries) ?? []
    }
}

class AssetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var balanceShown: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageTop: NSLayoutConstraint!
    @IBOutlet weak var userImageLeading: NSLayoutConstraint!
    @IBOutlet weak var userImageTrailing: NSLayoutConstraint!
    @IBOutlet weak var userImageBottom: NSLayoutConstraint!
    @IBOutlet weak var userImageHeight: NSLayoutConstraint!
    @IBOutlet weak var activityLeading: NSLayoutConstraint!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var topcoinLabel: UILabel!
    @IBOutlet weak var topcoinLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var topcoinLabelTop: NSLayoutConstraint!
    @IBOutlet weak var topcoinLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var topcoinLogoTrailing: NSLayoutConstraint!
    @IBOutlet weak var topcoinLogoBottom: NSLayoutConstraint!
    @IBOutlet weak var totalAssetsLabel: UILabel!
    @IBOutlet weak var balanceShownTop: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var activityTop: NSLayoutConstraint!
    @IBOutlet weak var sendTopcoin: UIButton!
    @IBOutlet weak var sendTopcoinHeight: NSLayoutConstraint!
    @IBOutlet weak var sendTopcoinLeading: NSLayoutConstraint!
    @IBOutlet weak var sendTopcoinTrailing: NSLayoutConstraint!
    @IBOutlet weak var sendTopcoinBottom: NSLayoutConstraint!
    @IBOutlet weak var sendTopcoinTop: NSLayoutConstraint!
    
    var transactions : [Transaction] = []
    
    var loaded: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addReusableViewController()
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            userImageTop.constant = 50
            userImageHeight.constant = 350
            activityTop.constant = 40
            sendTopcoinHeight.constant = 90
            sendTopcoin.titleLabel?.font = UIFont(name: "Arial", size: 30)
            sendTopcoinBottom.constant = 15
            sendTopcoinTop.constant = 30
            sendTopcoinLeading.constant = 100
            sendTopcoinTrailing.constant = 100
            activityLabel.font = UIFont(name: "Arial", size: 30)
            topcoinLabel.font = UIFont(name: "Nunito", size: 50)
            totalAssetsLabel.font = UIFont(name: "Arial", size: 25)
            balanceShown.font = UIFont(name: "Arial", size: 65)
            balanceShownTop.constant = 20
            topcoinLabelLeading.constant = 30
            topcoinLabelTop.constant = 30
            activityLeading.constant = 90
            userImageLeading.constant = 80
            userImageTrailing.constant = 80
            topcoinLogoHeight.constant = 75
            topcoinLogoBottom.constant = -35
            topcoinLogoTrailing.constant = -35
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15
        
        }
        
        //iPad Pro 10.5
        if view.frame.width == 834 {
            userImageTop.constant = 50
            userImageHeight.constant = 300
            activityTop.constant = 40
            sendTopcoinHeight.constant = 70
            sendTopcoin.titleLabel?.font = UIFont(name: "Arial", size: 25)
            sendTopcoinBottom.constant = 15
            sendTopcoinTop.constant = 30
            sendTopcoinLeading.constant = 100
            sendTopcoinTrailing.constant = 100
            activityLabel.font = UIFont(name: "Arial", size: 25)
            topcoinLabel.font = UIFont(name: "Nunito", size: 40)
            totalAssetsLabel.font = UIFont(name: "Arial", size: 20)
            balanceShown.font = UIFont(name: "Arial", size: 60)
            balanceShownTop.constant = 20
            topcoinLabelLeading.constant = 30
            topcoinLabelTop.constant = 30
            activityLeading.constant = 90
            userImageLeading.constant = 80
            userImageTrailing.constant = 80
            //            userImageBottom.constant = 70
            topcoinLogoHeight.constant = 65
            topcoinLogoBottom.constant = -35
            topcoinLogoTrailing.constant = -35
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15
        }
        
        //iPad Air, 5th Gen, 6th Gen
        if view.frame.width == 768 {
            userImageTop.constant = 50
            userImageHeight.constant = 300
            activityTop.constant = 40
            sendTopcoinHeight.constant = 70
            sendTopcoin.titleLabel?.font = UIFont(name: "Arial", size: 25)
            sendTopcoinBottom.constant = 15
            sendTopcoinTop.constant = 30
            sendTopcoinLeading.constant = 100
            sendTopcoinTrailing.constant = 100
            activityLabel.font = UIFont(name: "Arial", size: 25)
            topcoinLabel.font = UIFont(name: "Nunito", size: 40)
            totalAssetsLabel.font = UIFont(name: "Arial", size: 20)
            balanceShown.font = UIFont(name: "Arial", size: 60)
            balanceShownTop.constant = 20
            topcoinLabelLeading.constant = 30
            topcoinLabelTop.constant = 30
            activityLeading.constant = 90
            userImageLeading.constant = 80
            userImageTrailing.constant = 80
            //            userImageBottom.constant = 70
            topcoinLogoHeight.constant = 65
            topcoinLogoBottom.constant = -35
            topcoinLogoTrailing.constant = -35
            tableViewLeading.constant = 70
            tableViewTrailing.constant = 70
            tableViewTop.constant = 15
        }
        
        //        //iphone 5
        //        if view.frame.width == 320 {
        //        }
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            self.tableView.rowHeight = 130.0
        }
        else {
           self.tableView.rowHeight = 90.0
        }

        sendTopcoin.layer.cornerRadius = 0.5 * sendTopcoinHeight.constant
        sendTopcoin.clipsToBounds = true
        
        userImage.layer.borderWidth = 0
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = 5
        userImage.clipsToBounds = true
        
        
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
        
        reloadBalance()
    }
    
    func loadLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func getTransactions(callback: @escaping ([Transaction]) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        print("get transactions")
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/wallets/default/ledgerEntries")!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                print(String(data:data!,encoding: .utf8))
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(TransactionsDTO.self, from: data!)
                var transactions: [Transaction] = []
                for dto in responseModel.ledger_entries {
                    transactions.append(Transaction(
                        from_email: dto.from_email,
                        to_email: dto.to_email,
                        amount: dto.amount,
                        token_type: dto.token_type,
                        entry_time: dto.entry_time,
                        note: dto.note
                    ))
                }
                DispatchQueue.main.async {
                    print("transactions")
                    print(transactions)
                    callback(transactions)
                }
            } catch {
                print("JSON Serialization error")
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
    
    @IBAction func sendTopcoinButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "sendTopcoinSegue",sender: self)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getTransactions { transactions in
            self.transactions = transactions
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
        
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
        
        reloadBalance()
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            if let token = UserDefaults.standard.string(forKey: "token") {
                do {
                    try PFUser.logIn(withUsername: email, password: email)
                } catch {}
                return
            }
        }
        
//        self.loadLogin()
    }
    
    func getBalance(callback: @escaping (Double) -> Void) {
        print("get balance")
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/wallets/default/balance")!)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("ios-app-v1", forHTTPHeaderField: "App-Agent")
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                print(String(data:data!,encoding: .utf8))
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(BalanceDTO.self, from: data!)
                if let balance = responseModel.balance {
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
        
        //iPad Pro 12.9
        if view.frame.width == 1024 {
            cell.cellTextHeader.font = UIFont(name: "Arial", size: 25)
            cell.cellTextDescription.font = UIFont(name: "Arial", size: 20)
//            cell.sendImageHeight.constant = 50
//            cell.sendImage.layer.cornerRadius = 0.5 * cell.sendImageHeight.constant
//            cell.sendImage.clipsToBounds = true
            cell.cellTextHeaderLeading.constant = 50
            cell.balanceLabel.font = UIFont(name: "Arial", size: 25)
            
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
//            cell.sendImageHeight.constant = 50
//            cell.sendImage.layer.cornerRadius = 0.5 * cell.sendImageHeight.constant
//            cell.sendImage.clipsToBounds = true
            cell.cellTextHeaderLeading.constant = 50
            cell.balanceLabel.font = UIFont(name: "Arial", size: 25)
            
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
//            cell.sendImageHeight.constant = 50
//            cell.sendImage.layer.cornerRadius = 0.5 * cell.sendImageHeight.constant
//            cell.sendImage.clipsToBounds = true
            cell.cellTextHeaderLeading.constant = 50
            cell.balanceLabel.font = UIFont(name: "Arial", size: 25)
            
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
        
        let email = UserDefaults.standard.string(forKey: "email")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let transaction = transactions[indexPath.row]
        
        let received = email.lowercased() == transaction.to_email.lowercased()
        
        print("\(email.lowercased()) ==? \(transaction.to_email.lowercased())")
        
        cell.balanceLabel.text = "\(received ? "" : "-")\(transaction.amount)"
        if received {
            cell.balanceLabel.textColor = UIColor(red: 76/255, green: 191/255, blue: 44/255, alpha: 1)
        }
        if received {
//            cell.sendImage.image = UIImage(named: "downArrow")
            cell.cellTextHeader.text = "Received"
            var sender = transaction.from_email
            switch sender {
            case "admin@topcoin.network":
                sender = "Topcoin"
                break
            default:
                break
            }
            cell.cellTextDescription.text = "from \(sender)"
        } else {
            cell.balanceLabel.textColor = UIColor(red: 84/255, green: 84/255, blue: 86/255, alpha: 1)
//            cell.sendImage.image = UIImage(named: "upArrow")
            cell.cellTextHeader.text = "Sent"
            var recipient = transaction.to_email
            switch recipient {
            case "topcoin@domainoutlet.com":
                recipient = "Domain Outlet"
                break
            case "topcoin@emojidomainnames.com":
                recipient = "Emoji Domain Names"
                break
            case "topcoin@namejelly.com":
                recipient = "Name Jelly"
                break
            default:
                break
            }
            cell.cellTextDescription.text = "to \(recipient)"
        }
        
//        switch (indexPath.section, indexPath.row) {
//
//        case (0,0):
//            if(UserDefaults.standard.object(forKey: "balance") == nil){
//                if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1){
//                    cell.balanceLabel.text = "100.00"
//                    cell.sendImage.image = UIImage(named: "downArrow")
//                    cell.cellTextHeader.text = "Received"
//                    cell.cellTextDescription.text = "from Topcoin"
//                }else{
//                    cell.balanceLabel.text = ""
//                    cell.sendImage.image = UIImage(named: "topcoinLogoDarkSmall")
//                    cell.cellTextHeader.text = "No transactions yet"
//                    cell.cellTextDescription.text = "Transaction details here"
//                }
//            }else{
//                if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1){
//                    cell.balanceLabel.text = "100.00"
//                    cell.sendImage.image = UIImage(named: "downArrow")
//                    cell.cellTextHeader.text = "Received"
//                    cell.cellTextDescription.text = "from Topcoin"
//                }else{
//                    let balance = UserDefaults.standard.double(forKey: "balance")
//                    cell.balanceLabel.text = "\(balance)0"
//                    cell.sendImage.image = UIImage(named: "downArrow")
//                    cell.cellTextHeader.text = "Received"
//                    cell.cellTextDescription.text = "from Uniregistry"
//                }
//            }
//
//        case (0,1):
//            if(UserDefaults.standard.object(forKey: "balance") == nil){
//                cell.isHidden = true
//            }else{
//                if(UserDefaults.standard.integer(forKey: "earnedTopcoin") == 1){
//                    let balance = UserDefaults.standard.double(forKey: "balance")
//                    cell.balanceLabel.text = "\(balance)0"
//                    cell.sendImage.image = UIImage(named: "downArrow")
//                    cell.cellTextHeader.text = "Received"
//                    cell.cellTextDescription.text = "from Uniregistry"
//                }else{
//                    cell.isHidden = true
//                }
//            }
//        default : break
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        let hasBalanace = UserDefaults.standard.object(forKey: "balance") != nil
//        return hasBalanace ? 2 : 2
        return self.transactions.count
    }
    
    func loadHomeScreen() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AssetsViewController") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }

}


