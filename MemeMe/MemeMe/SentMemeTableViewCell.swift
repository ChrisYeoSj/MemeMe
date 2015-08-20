//
//  SentMemeTableViewCell.swift
//  MemeMe
//
//  Created by Christopher on 20/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

class SentMemeTableViewCell: UITableViewCell {
    

    @IBOutlet var memedImageView: UIImageView!
    @IBOutlet var memedTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
