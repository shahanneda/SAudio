//
//  MediaTableViewCell.swift
//  SAudio
//
//  Created by Shahan Nedadahandeh on 2018-11-11.
//  Copyright © 2018 Shahan Nedadahandeh. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var NameLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        NameLabel.sizeToFit()
        // Initialization code
    }
    public func SetCheckmark(){
        self.accessoryType = .checkmark
        self.setNeedsDisplay()
        self.setNeedsLayout()
        
    }
    public func RemoveCheckmark(){
        self.accessoryType = .none
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
       // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
