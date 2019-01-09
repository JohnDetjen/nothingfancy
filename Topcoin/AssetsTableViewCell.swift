//
//  AssetsTableViewCell.swift
//  Topcoin
//
//  Created by John Detjen on 12/7/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit

class AssetsTableViewCell: UITableViewCell {
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var transactionContact: UILabel!
    @IBOutlet weak var balanceHidden: UILabel!
    @IBOutlet weak var balanceShown: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        balanceShown.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
