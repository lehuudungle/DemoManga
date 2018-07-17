//
//  FeaturedAppsController.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FeaturedAppsController: UICollectionViewController,UICollectionViewDelegateFlowLayout,GADBannerViewDelegate{
    private let cellId = "cellId"
    var TypeApp: [AppCategory] = [AppCategory(name: "Populator"),AppCategory(name: "New Manga"),AppCategory(name: "Last Update")]
    var listJSON = [MangaCollectionViewModel]()
    var genre = [String]()
    var source = ""
    var urlPage = 1
    var option = ""
    var listOption: [String] = ["popular","new","update"]
    var url = ""
    var temp = 0
    fileprivate let headerId = "headerId"

    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-9163384915202343/4116857116"
        adBannerView.delegate = self
        adBannerView.rootViewController = self

        return adBannerView
    }()
    
    override func viewDidLoad() {
        print("load featue 2 lan")

        downloadFirstData()
        self.collectionView?.backgroundColor  = UIColor.white
        self.collectionView!.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.register(headerView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        adBannerView.load(GADRequest())
//        loadUI()

    }
    func downloadFirstData(){
        

            source = sources
            option = "popular"
            url = String(format: urlCollectionManga, source, listOption[temp], urlPage)
            loadUI()


            //
            option = "new"
            url = String(format: urlCollectionManga, source, option, urlPage)
            loadUI()

            //
            option = "update"
            url = String(format: urlCollectionManga, source, option, urlPage)
            loadUI()

            


            
            self.collectionView?.reloadData()

    }
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadUI() {
        //        DownloadManager.shared.downloadJSONForMangaCollectionView(url: <#T##String#>, completed: <#T##([MangaCollectionViewModel]) -> Void#>)
        DownloadManager.shared.downloadJSONForMangaCollectionView(url: url) { (complete) in
            if self.genre.count > 0 {
                for item in complete {
                    for genreItem in item.genre {
                        if let index = self.genre.index(of: genreItem) {
                            self.listJSON.append(item)
                            break
                        }
                    }
                }
            }

            else {
                self.listJSON = [MangaCollectionViewModel]()
                self.listJSON.append(contentsOf: complete)
                self.TypeApp[self.temp].apps = self.listJSON
                print("typeApp: \(self.TypeApp[self.temp].apps?.count)")
                self.collectionView?.reloadData()
                self.temp += 1
            }

            self.collectionView?.reloadData()
            for item in self.listJSON {

                DownloadManager.shared.downloadImage(url: item.avatarURL) { (complete) in
                    item.avatar = complete
                    self.collectionView?.reloadData()
                }
            }

            if self.listJSON.count < 9 {
                //                self.updateUrlPage()
            }
            
        }
        
        
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.url = url
        cell.appCategory = self.TypeApp[indexPath.item]
        cell.currentPage = indexPath.item
    

        // Configure the cell

        return cell
    }
    // add UICollectionViewDelegateFlowLayout moi  doi kich thuoc cac cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("celll \(view.frame.width)____\(view.frame.height)")
        return CGSize(width: view.frame.width, height: 230)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! headerView
        header.addSubview(self.adBannerView)
        
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.adBannerView.frame.width, height: self.adBannerView.frame.height)
    }

    
}

extension FeaturedApps{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("add banner successfully")
//        //        tableView.tableHeaderView?.frame = bannerView.frame
//        //        tableView.tableHeaderView = bannerView
//        print("banner: \(bannerView.frame)")
//        //        self.navigationController?.navigationBar.frame = bannerView.frame
//        //        self.navigationController?.navigationBar.addSubview(bannerView)
//        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
//        bannerView.transform = translateTransform
//
//        UIView.animate(withDuration: 0.5) {
//            self.tableView.tableHeaderView?.frame = bannerView.frame
//            bannerView.transform = CGAffineTransform.identity
//            self.tableView.tableHeaderView = bannerView
//        }


    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
class headerView: UICollectionReusableView{


}
