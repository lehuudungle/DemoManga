
//
//  DetaillLIstCollectionView.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DetaillLIstCollectionView: UICollectionViewController,UICollectionViewDelegateFlowLayout,GADInterstitialDelegate {
    var listJSON = [MangaCollectionViewModel]()

    var url = ""

    var urlPage = 1
    var source = ""
    var option = ""
    var genre = [String]()
    var interstitial: GADInterstitial?
    var isFiter = false
    var delegateFilter: FilterResultView!

    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Register cell classes

        let nib = UINib(nibName: "DetailListCollectionCellView", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "DetailListCollectionCellView")
//        self.collectionView!.register(DetailListCollectionCellView.self, forCellWithReuseIdentifier: "DetailListCollectionCellView")
        print("list song: \(self.listJSON.count)")
        self.collectionView?.backgroundColor = UIColor.white
        let rightFilteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action:#selector(self.filterTapped))
        let rightSearchBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(self.searchTapped(_:)))
        self.navigationItem.setRightBarButtonItems([rightFilteBarButtonItem,rightSearchBarButtonItem], animated: true)
        interstitial = createAndLoadInterstitial()


    }
    func filterTapped(){

    }
    func searchTapped(_ sender: UIBarButtonItem){
         
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"searchView"), object: nil)
        
    }
    
    func fillURL() {

        var urlString = String(format: urlCollectionManga, source, option, urlPage)
        print("urlString: \(urlString)")
        updateURL(url: urlString)
    }
    

    func updateURL(url: String) {
        print("url collection: \(url)")
        self.url = url
        loadUI()
    }
    func updateUrlPage() {
        print("khi push: \(urlPage)")
        if urlPage > 20 {
            return
        }
        urlPage += 1
        var urlString = String(format: urlCollectionManga, source, option, urlPage)
        updateURL(url: urlString)
    }
    func loadUI() {
        DownloadManager.shared.downloadJSONForMangaCollectionView(url: url) { (complete) in
            if self.genre.count > 0 {

                for item in complete {
                    for genreItem in item.genre {

                        if let index = self.genre.index(of: genreItem.uppercaseFirst) {

                            self.listJSON.append(item)
                            break
                        }
                    }
                }
                print("so list filter: \(self.listJSON.count)")
            }

            else {
                print("load genre")
                self.listJSON.append(contentsOf: complete)
            }

            self.collectionView?.reloadData()
            print("so truyen tim duoc: \(self.listJSON.count)")
            for item in self.listJSON {
                DownloadManager.shared.downloadImage(url: item.avatarURL) { (complete) in
                    item.avatar = complete
                    self.collectionView?.reloadData()
                }
            }
            if(self.isFiter){
                 print("so truyen istim duoc: \(self.listJSON.count)")
                if(self.listJSON.count==0){
                    print("hien thong bao")
                    let alert = UIAlertController(title: "Alert", message: " Khong tim thay truyen mong muon", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: {action in
                        alert.dismiss(animated: true, completion: nil)
                        
                    }))


                    self.present(alert, animated: true, completion: nil)
                }
            }
            print("so listJSON: \(self.listJSON.count)")
            if self.listJSON.count < 9 {
//                self.updateUrlPage()
            }

        }

        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if listJSON == nil {
            return 0
        }
        print("list song: \(self.listJSON)")
        return self.listJSON.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailListCollectionCellView", for: indexPath) as! DetailListCollectionCellView
        print("doi tuong cell: \(cell)")
        print("list:\(listJSON[indexPath.row].avatar)")
        
        cell.image.image = listJSON[indexPath.row].avatar
        cell.name.text = listJSON[indexPath.row].name
        print("cell name: \(cell.name.text)")

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("collection view layout: \(collectionView.frame.size.width/2)")
        print("frame collection: \(collectionView.frame.size.width) \(collectionView.frame.size.height)")
        return CGSize(width: CGFloat(collectionView.frame.size.width / 3),
                      height: CGFloat(collectionView.frame.size.width / 2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushInfoView"), object: nil, userInfo: ["storyID": listJSON[indexPath.row].id])
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            updateUrlPage()
            print("update")
        }
    }


    
}
extension DetaillLIstCollectionView{
    func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9163384915202343/5593590318")

        guard let interstitial = interstitial else {
            return nil
        }

        let request = GADRequest()
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self

        return interstitial
    }
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial!) {
        print("Fail to receive interstitial")
    }
}
