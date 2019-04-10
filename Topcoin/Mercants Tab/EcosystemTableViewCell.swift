//
//  EcosystemTableViewCell.swift
//  Topcoin
//
//  Created by John Detjen on 2/23/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit

class EcosystemTableViewCell: UITableViewCell {

    @IBOutlet weak var merchantImage: UIImageView!
    @IBOutlet weak var merchantImageHeight: NSLayoutConstraint!
    @IBOutlet weak var merchantLabel: UILabel!
    @IBOutlet weak var merchantDescription: UILabel!
    @IBOutlet weak var merchantLabelLeading: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        merchantImage.layer.cornerRadius = merchantImage.frame.height/2
        merchantImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
