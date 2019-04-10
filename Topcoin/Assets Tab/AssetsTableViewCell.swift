//
//  AssetsTableViewCell.swift
//  Topcoin
//
//  Created by John Detjen on 12/7/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit

class AssetsTableViewCell: UITableViewCell {
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cellTextHeader: UILabel!
    @IBOutlet weak var cellTextDescription: UILabel!
    @IBOutlet weak var cellTextHeaderLeading: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
