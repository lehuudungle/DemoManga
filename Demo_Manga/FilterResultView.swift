//
//  FilterResultView.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class FilterResultView: UIViewController {

    var filterList: [String]!
    var collectionView: DetaillLIstCollectionView!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("filter list: \(filterList)")
        self.navigationItem.title = "Manga Filter"
        let layout = UICollectionViewFlowLayout()
        collectionView = DetaillLIstCollectionView(collectionViewLayout: layout)
        collectionView.source = sources
        collectionView.option = "popular"
        collectionView.genre = filterList
        collectionView.isFiter = true
//        collectionView.fillURL()
        let stringUrl = String(format: urlSearchManga, sources)
        collectionView.updateURL(url: stringUrl)
    }
    override func viewDidLayoutSubviews() {
        collectionView.view.frame = self.contentView.frame
        collectionView.view.frame.origin.x = 0
        collectionView.view.frame.origin.y = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.collectionView?.reloadData()
        self.contentView.addSubview(self.collectionView.view)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPagerTabStrip"), object: nil)
    }

        


}
