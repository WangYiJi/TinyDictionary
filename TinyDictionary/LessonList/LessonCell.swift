//
//  LessonCell.swift
//  TinyDictionary
//
//  Created by wyj on 2018/6/8.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class LessonCell: UITableViewCell {
    @IBOutlet weak var lblGerman: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
