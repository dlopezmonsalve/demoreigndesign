//
//  StoriesCell.swift
//  Demo ReignDesign
//
//  Created by Daniel López  on 11-09-17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class StoriesCell: MGSwipeTableCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
