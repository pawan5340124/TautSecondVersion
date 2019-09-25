//
//  headerTableViewCell.swift
//  Taut
//
//  Created by Matrix Marketers on 02/05/19.
//  Copyright © 2019 Matrix Marketers. All rights reserved.
//

import UIKit

class headerTableViewCell: UITableViewCell {

    @IBOutlet weak var btnHeaderButtonCLick: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewMain: UIView!
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
