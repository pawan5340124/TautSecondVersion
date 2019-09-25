//
//  MyChatTableViewCell.swift
//  Taut
//
//  Created by Matrix Marketers on 03/05/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imgthread: UIImageView!
    @IBOutlet weak var lblthreadReply: UILabel!
    @IBOutlet weak var con_HeightThreadreply: NSLayoutConstraint!
    @IBOutlet weak var ViewThreadReply: UIView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var Con_Emoji_Height: NSLayoutConstraint!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var ViewEmoji: UIView!
    @IBOutlet weak var viewMessageBoundry: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
