//
//  SelfieCell.swift
//  w1d2 selfigram
//
//  Created by Nitin Panchal on 2017-08-24.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//

import UIKit

class SelfieCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
