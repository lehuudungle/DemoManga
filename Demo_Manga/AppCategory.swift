//
//  AppCategory.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/8/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


class FeaturedApps: NSObject{

}
class AppCategory: NSObject {

    var name: String?
    var apps: [MangaCollectionViewModel]?
    init(name: String) {
        self.name = name
    }

}
