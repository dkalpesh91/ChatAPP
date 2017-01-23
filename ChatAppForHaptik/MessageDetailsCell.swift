//
//  MessageDetailsCell.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/21/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

class MessageDetailsCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalMessageLabel: UILabel!
    @IBOutlet weak var totalFavoritesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
