//
//  TransferRecipientTableViewCell.swift
//  Topcoin
//
//  Created by John Detjen on 2/14/19.
//  Copyright © 2019 Topcoin. All rights reserved.
//

import UIKit

class TransferRecipientTableViewCell: UITableViewCell {
    @IBOutlet weak var sendImage: UIImageView!
    @IBOutlet weak var sendImageHeight: NSLayoutConstraint!
    @IBOutlet weak var cellTextHeaderLeading: NSLayoutConstraint!
    @IBOutlet weak var cellTextHeader: UILabel!
    @IBOutlet weak var cellTextDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sendImage.layer.cornerRadius = sendImage.frame.height/2
        sendImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
