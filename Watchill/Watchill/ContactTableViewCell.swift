//
//  ContactTableViewCell.swift
//  Watchill
//
//  Created by Laricia Mota on 10/05/19.
//  Copyright © 2019 Laricia Mota. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }
    
}
