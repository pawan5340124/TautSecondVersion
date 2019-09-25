//
//  AnotherUserChatTableViewCell.swift
//  Taut
//
//  Created by Matrix Marketers on 03/05/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit

class AnotherUserChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblThreadCount: UILabel!
    @IBOutlet weak var imgThread: UIImageView!
    @IBOutlet weak var con_heightThreadReply: NSLayoutConstraint!
    @IBOutlet weak var viewThreadReply: UIView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var con_ViewEmoji: NSLayoutConstraint!
    @IBOutlet weak var ViewEmoji: UIView!
    @IBOutlet weak var viewMessageBoundry: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ImgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
