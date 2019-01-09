//
//  MeTableViewCell.swift
//  Topcoin
//
//  Created by John Detjen on 12/10/18.
//  Copyright © 2018 Topcoin. All rights reserved.
//

import UIKit

class MeTableViewCell: UITableViewCell {

    

    @IBOutlet weak var meImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
