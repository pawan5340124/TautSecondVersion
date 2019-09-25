//
//  BoadyTableViewCell.swift
//  Taut
//
//  Created by Matrix Marketers on 03/05/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit

class BoadyTableViewCell: UITableViewCell {

    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var LBLCOUNT: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
