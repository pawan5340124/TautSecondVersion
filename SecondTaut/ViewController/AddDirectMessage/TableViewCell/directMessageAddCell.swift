//
//  directMessageAddCell.swift
//  Taut
//
//  Created by Matrix Marketers on 11/06/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit

class directMessageAddCell: UITableViewCell {

    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var lblPossition: UILabel!
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
