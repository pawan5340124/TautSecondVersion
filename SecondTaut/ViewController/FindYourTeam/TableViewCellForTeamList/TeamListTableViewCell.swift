//
//  TeamListTableViewCell.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 30/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnteamSelect: UIButton!
    @IBOutlet weak var lblteamUrl: UILabel!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var imgteam: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
