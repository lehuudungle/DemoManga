//
//  AllManageView.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AllManageView: UIViewController,IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALL MANGA")
    }
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    var tableView: listMangaTable!
    let url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        tableView = listMangaTable()
        print("doi tuong tableView: \(tableView)")
        let urlString = "http://45.32.225.81/getallstory?version_app=v1.1&source=mangafox"
        tableView.updateURL(url: urlString)
        NotificationCenter.default.addObserver(self, selector: #selector(stopActivityView), name: NSNotification.Name(rawValue: "stopActivityView"), object: nil)


     }
        override func viewDidLayoutSubviews() {
            self.view.addSubview(self.tableView.view)
            self.view.addSubview(activityView)
            tableView.view.frame = self.view.frame
            tableView.view.frame.origin.x = 0
            tableView.view.frame.origin.y = 0
            self.activityView.center = self.tableView.view.center

        }

        override func viewDidAppear(_ animated: Bool) {

            self.tableView.tableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPagerTabStrip"), object: nil)
        }
    func stopActivityView(){
        self.activityView.stopAnimating()
        self.activityView.isHidden = true

    }

    
    
    
}
