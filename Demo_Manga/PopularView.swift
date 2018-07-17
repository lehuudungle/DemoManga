//
//  PopularView.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class PopularView: UIViewController,IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "POPULAR")
    }
    var tableView: listMangaTable!
    override func viewDidLoad() {
        super.viewDidLoad()


    }


    
}
