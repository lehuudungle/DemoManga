//
//  SourcesModel.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class SourcesModel {
    var name: String
    var slug: String
    var nation: String

    init(name: String, slug: String, nation: String) {
        self.name = name
        self.slug = slug
        self.nation = nation
    }
}

