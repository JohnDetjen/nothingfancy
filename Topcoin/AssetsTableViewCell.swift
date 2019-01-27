//
//  AssetsTableViewCell.swift
//  Topcoin
//
//  Created by John Detjen on 12/7/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit

class AssetsTableViewCell: UITableViewCell {
    @IBOutlet weak var sendImage: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cellTextHeader: UILabel!
    @IBOutlet weak var cellTextDescription: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        balanceShown.isHidden = true
        
//        //iPad Pro 12.9
//        if frame == 1024 {
//
//        }
//
//        //iPad Pro 10.5
//        if view.frame.width == 834 {
//
//        }
//
//        //iPad Air, 5th Gen
//        if view.frame.width == 768 {
//
//        }
//
//                //iphone 5
//        if view.frame.width == 320 {
//        }
        
        sendImage.layer.cornerRadius = sendImage.frame.height/2
        sendImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                        self.balanceLabel.text = "\(balance)"
                    }
                }
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }

}
