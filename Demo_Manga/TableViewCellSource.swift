//
//  TableViewCellSource.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import M13Checkbox

class TableViewCellSource: UITableViewCell {

    @IBOutlet weak var checkBox: M13Checkbox!
    
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
}
