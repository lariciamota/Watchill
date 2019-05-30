//
//  MusicTableViewCell.swift
//  Watchill
//
//  Created by Laricia Mota on 29/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    @IBOutlet weak var musicLabel: UILabel!
    
    @IBOutlet weak var lockedSymbol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
