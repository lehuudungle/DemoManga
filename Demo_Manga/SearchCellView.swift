//
//  SearchCellView.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SearchCellView: UITableViewCell {


    @IBOutlet weak var nameImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var year: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
