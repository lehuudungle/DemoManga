//
//  FavoritesViewController.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/18/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class FavoritesViewController: UIViewController,GADInterstitialDelegate {

    var data = [Favorites]()
    var interstitial: GADInterstitial?

    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        interstitial = createAndLoadInterstitial()

    }
    override func viewDidAppear(_ animated: Bool) {
        loadDatabase()
    }
    func loadDatabase(){
        let realm = try! Realm()
        let allFavorites = realm.objects(Favorites.self)
        data.removeAll()
        data.append(contentsOf: allFavorites)
        collectionView.reloadData()
        
    }


}
extension FavoritesViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        let image =  cell.viewWithTag(100) as! UIImageView
        let name = cell.viewWithTag(101) as! UILabel
        image.image = UIImage.init(data: data[indexPath.row].mangaImage as Data)
        name.text = data[indexPath.row].name
//        name.textColor = UIColor.red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MangaInfoViewController") as! MangaInfoViewController
        vc.storyID = data[indexPath.row].storyID

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension FavoritesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width/3), height: CGFloat(collectionView.frame.width/2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FavoritesViewController{
     func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8501671653071605/2568258533")

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
