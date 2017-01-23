//
//  ChatDetailsTableViewCell.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/20/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

class ChatDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var chatMessageLabel: UILabel!
    @IBOutlet weak var favoritesImageview: UIImageView!
    @IBOutlet weak var chatTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
