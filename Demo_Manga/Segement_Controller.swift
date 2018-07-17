//
//  Segement_Controller.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/6/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit
import XLPagerTabStrip
class Segement_Controller: SegmentedPagerTabStripViewController {

    
    @IBOutlet weak var segement: UISegmentedControl!

    override func viewDidLoad() {
        
        self.segmentedControl = segement

        self.settings.style.segmentedControlColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        super.viewDidLoad()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {


        let child1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowView")
        let child2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopularView")
        let child3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllMangaView")


        return [child1,child3]
    }
    func reloadPagerTabStrip() {
        updateContent()
    }

}
