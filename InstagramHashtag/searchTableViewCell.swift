//
//  searchTableViewCell.swift
//  InstagramHastag
//
//  Created by Kevin Kim on 10/18/15.
//  Copyright © 2015 Kevin Kim. All rights reserved.
//

import UIKit

class searchTableViewCell: UITableViewCell {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var numOfLikes1: UILabel!
    @IBOutlet weak var numOfLikes2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
