//
//  ShowView.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ShowView: UIViewController,IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "FEATURED")
    }
    var featuredAppsController:FeaturedAppsController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        self.featuredAppsController = FeaturedAppsController(collectionViewLayout: layout)
          
    }

        override func viewDidLayoutSubviews(){

            self.featuredAppsController.view.frame = self.view.frame
            self.featuredAppsController.view.frame.origin.x = 0

        }

    override func viewDidAppear(_ animated: Bool) {


        self.view.addSubview(self.featuredAppsController.view)

    }




}
