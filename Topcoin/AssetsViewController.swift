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

class AssetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var balanceShown: UILabel!
    
    var tasks = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReusableViewController()
        getBalance()
        
        
//        let blockies = Blockies(
//            seed: "0x869bb8979d38a8bc07b619f9d6a0756199e2c724",
//            size: 25,
//            scale: 100,
////            color: UIColor.yellow,
////            bgColor: UIColor.orange,
////            spotColor: UIColor.white
//            color: UIColor(red: 1, green: 0.8274, blue: 0.45, alpha: 1.0),
//            bgColor: UIColor(red: 1, green: 0.8549, blue: 0.3647, alpha: 1.0),
//            spotColor: UIColor(red: 1, green: 0.7568, blue: 0.00784, alpha: 1.0)
//            
//        )
//        let img = blockies.createImage()
//        
//        userImage.image = img
        userImage.layer.borderWidth = 2
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = 5
//        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }
    
    func getBalance() {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        var request = URLRequest(url: URL(string: "https://api.topcoin.network/origin/api/v1/public/accountBalance/\(email)")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(BalanceDTO.self, from: data!)
                DispatchQueue.main.async {
                    if let balance = responseModel.old_balance {
                        self.balanceShown.text = "\(balance)"
                    }
                }
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.string(forKey: "email") == nil {
            if let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeViewController {
                let loginNavigation = UINavigationController(rootViewController: welcomeVC)
                self.present(loginNavigation, animated: true, completion: nil)
//                self.navigationController?.present(welcomeVC, animated: true)
            }
        }
        
        
        getBalance()
        
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

    
//    @IBAction func showBalanceButton(_ sender: Any) {
//
//        if closedEye.isSelected == true {
//            closedEye.isSelected = false
//            closedEye.setImage(UIImage(named : "closedEye"), for: UIControl.State.normal)
//        }else {
//            closedEye.isSelected = true
//            closedEye.setImage(UIImage(named : "openEye"), for: UIControl.State.normal)
//        }
//
//        balanceShown.isHidden = !balanceShown.isHidden
//        balanceHidden.isHidden = !balanceShown.isHidden
//    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AssetsTableViewCell
        
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.transactionContact.text = "4509210810..42L"
            cell.transactionImage.image = UIImage(named: "userIcon")
            cell.transactionDate.text = "Pending confirmation"
            
        default : break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

}


