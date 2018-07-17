//
//  MangaInfoViewController.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/4/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import RealmSwift
import GoogleMobileAds

class MangaInfoViewController:UIViewController, MWPhotoBrowserDelegate,GADInterstitialDelegate {




    var url = ""
    var storyID = 0
    var dataJSON = MangaInfoModel()
    var dataDownload = Download()


    @IBOutlet weak var mangaImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var updateAt: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    @IBOutlet weak var sumaryView: UIView!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var summary: UITextView!

    @IBOutlet weak var chapterView: UIView!
    var tableView = TableViewMangaChapter()
    var photo = [Any]()
    var isFromDownload = false
    var interstitial: GADInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        segmentControl.tintColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        print("load 2 lan")
        print("navigation info: \(self.navigationController?.viewControllers.description)")
        self.tableView = Bundle.main.loadNibNamed("TableViewMangaChapter", owner: nil, options: nil)?.first as! TableViewMangaChapter
        let rightFavoriteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Favorite"), style: .plain, target: self, action: #selector(self.favoriteTapped))
        
        self.navigationItem.setRightBarButtonItems([rightFavoriteBarButtonItem,rightDownloadBarButtonItem], animated: true)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black

        if !isFromDownload{
            print("story ID: \(storyID)")
            url = String(format:urlMANGAInfo,storyID)
            getJSON()

        }else{
            loadDatabase()
        }
        chapterView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(pushReadVC(_:)), name: NSNotification.Name(rawValue: "pushReadVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downloadChap(_:)), name: NSNotification.Name(rawValue: "downloadChap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(autoOpenChap(_:)), name: NSNotification.Name(rawValue: "autoOpenChap"), object: nil)


        
    }
    func loadDatabase() {
        self.mangaImage.image = UIImage.init(data: dataDownload.mangaImage as Data)
        self.navigationItem.title = dataDownload.name
        name.text = dataDownload.name
        author.text = "Author: " + dataDownload.author // lấy 1 thôi, ko cần nhiều LOL
        status.text = "Status: " + dataDownload.status
        updateAt.text = "Update At: " + dataDownload.updateAt
        total.text = "Total: " + String(dataDownload.total) + " chapters"
        genres.text = dataDownload.genre
        summary.text = dataDownload.describe

        var a = [ChapModel]()
        for item in dataDownload.chap {
            let b = ChapModel()
            b.chap = item.chap
            b.chapID = item.chapID
            a.append(b)
            print(b.chapID)
        }
        tableView.data = a
        tableView.isFromDownload = true
        tableView.reload()
    }
    
    func pushReadVC(_ notification: NSNotification) {

        //realm recent
        let chap = Recent()


        chap.mangaImage = NSData(data: UIImageJPEGRepresentation(mangaImage.image!,0.9)!)
        chap.time = NSDate()
        chap.name = self.name.text!
        if let chapID = notification.userInfo?["chapID"] as? Int {
            print("chap id:\(chapID)")
            chap.chapID = chapID
            
        }
        if let chapNumber = notification.userInfo?["chapNumber"] as? Double {
            print("chapNumber: \(chapNumber)")
            
            chap.chap = chapNumber
        }
        if !isFromDownload {
            chap.storyID = dataJSON.id
        }
        else {
            chap.storyID = dataDownload.storyID
        }

        let realm = try! Realm()
        try! realm.write {
            print("chapId info: \(chap.storyID)")
            print("filter truyen: \(realm.objects(Recent.self).filter("storyID == %@", chap.storyID))")
            realm.delete(realm.objects(Recent.self).filter("storyID == %@", chap.storyID))

            realm.add(chap)
        }



        //MWPhotoBrowser
        let browser = MWPhotoBrowser(delegate: self)

        browser?.displayActionButton = true
        browser?.displayNavArrows = true
        browser?.displaySelectionButtons = false
        browser?.zoomPhotosToFill = true
        browser?.alwaysShowControls = false
        browser?.enableGrid = false
        browser?.startOnGrid = false
        browser?.autoPlayOnAppear = false
        browser?.setCurrentPhotoIndex(0)

        if let chapID = notification.userInfo?["chapID"] as? Int {
            if !isFromDownload {
                let urlString = String(format: urlChapter, chapID)
                print("url chap truyen: \(urlString)")
                photo.removeAll()
                DownloadManager.shared.downloadChapterInfo(url: urlString) { (complete) in
                    for item in complete.listImgURL {
                        guard let genreUrl = URL(string: item) else {
                            return
                        }

                        self.photo.append(MWPhoto(url: genreUrl))
                    }
                    self.navigationController?.pushViewController(browser!, animated: true)
                    browser?.showNextPhoto(animated: true)
                    browser?.showPreviousPhoto(animated: true)
                }
            }
            else {

                photo.removeAll()
                let chapDownload = realm.objects(ChapDownloadModel.self).filter("chapID == %@", chapID)
                for item in (chapDownload.first?.chapImage)! {
                    self.photo.append(MWPhoto(image: UIImage.init(data: item.chapImage as Data)))
                }
                self.navigationController?.pushViewController(browser!, animated: true)
                browser?.showNextPhoto(animated: true)
                browser?.showPreviousPhoto(animated: true)
 
            }
        }


    }
    func downloadChap(_ notification: NSNotification){
        if let chap = notification.userInfo?["chap"] as? ChapModel {

            let realm = try! Realm()
            print("realm: \(realm.configuration.description)")

            if let a = realm.object(ofType: Download.self, forPrimaryKey: storyID) { // nếu đã có sẵn cái Manga, thì chỉ cần thêm 1 ChapDownloadModel
                try! realm.write {
                    if let b = realm.objects(ChapDownloadModel.self).filter("chapID == %@", chap.chapID).first {
                        return
                    }

                    a.total += 1
                    let chapDownload = ChapDownloadModel()
                    chapDownload.chapID = chap.chapID
                    chapDownload.chap = chap.chap

                    //lấy chap image
                    let urlString = String(format: urlChapter, chap.chapID)
                    DownloadManager.shared.downloadChapterInfo(url: urlString) { (complete) in // lấy list url image
                        for item in complete.listImgURL {
                            //self.photo.append(MWPhoto(url: genreUrl))
                            DownloadManager.shared.downloadImage(url: item) { (image) in // lấy image
                                var b = ChapImageModel()
                                b.chapImage = NSData(data: UIImageJPEGRepresentation(image,0.9)!)
                                try! realm.write {
                                    chapDownload.chapImage.append(b)
                                }
                            }
                        }
                    }

                    a.chap.append(chapDownload)
                }
                return
            }

            else {
                try! realm.write {
                    let download = Download()

                    download.mangaImage = NSData(data: UIImageJPEGRepresentation(mangaImage.image!,0.9)!)
                    download.name = self.name.text!
                    download.storyID = dataJSON.id

                    download.author = dataJSON.author[0]
                    download.genre = dataJSON.genre
                    download.describe = dataJSON.describe
                    download.updateAt = dataJSON.updateAt
                    download.status = dataJSON.status
                    download.total += 1

                    let chapDownload = ChapDownloadModel()
                    chapDownload.chapID = chap.chapID
                    chapDownload.chap = chap.chap

                    //lấy chap image
                    let urlString = String(format: urlChapter, chap.chapID)
                    DownloadManager.shared.downloadChapterInfo(url: urlString) { (complete) in // lấy list url image
                        for item in complete.listImgURL {
                            //self.photo.append(MWPhoto(url: genreUrl))
                            DownloadManager.shared.downloadImage(url: item) { (image) in // lấy image
                                var b = ChapImageModel()
                                b.chapImage = NSData(data: UIImageJPEGRepresentation(image,0.9)!)
                                //chapDownload.chapImage.append(b)
                                try! realm.write {
                                    chapDownload.chapImage.append(b)
                                }
                            }
                        }
                    }

                    download.chap.append(chapDownload)

                    realm.add(download)
                }
                
            }
        }
    }
    public func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photo.count)
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if Int(index) < self.photo.count {
            return photo[Int(index)] as! MWPhoto
        }


        return nil
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: 0, width: chapterView.frame.width, height: chapterView.frame.height)
        chapterView.addSubview(tableView)
    }
    func getJSON(){

        DownloadManager.shared.downloadMangaInfo(url: url) { (complete) in
            self.dataJSON = complete
            DownloadManager.shared.downloadImage(url: self.dataJSON.avatarURL) { (complete) in
//                self.mangaImage.image = complete
                self.mangaImage.image = complete
                print("doi tuong anh: \(self.mangaImage.image)")
            }
            self.loadUI()
        }
    }
    func loadUI(){
        self.navigationItem.title = dataJSON.name
        name.text = dataJSON.name
        author.text = "Author: " + dataJSON.author[0]
        status.text = "Status: " + dataJSON.status
        updateAt.text = "Update At: " + dataJSON.updateAt
        total.text = "Total: " + String(dataJSON.total)  + "chapters"
        genres.text = dataJSON.genre
        summary.text = dataJSON.describe
        tableView.data = dataJSON.chaps
        tableView.reload()

    }
   
    func favoriteTapped(){
        let favorite = Favorites()
        favorite.mangaImage = NSData(data: UIImageJPEGRepresentation(mangaImage.image!, 0.9)!)
        favorite.name = self.name.text!
        favorite.storyID = dataJSON.id
        let realm = try! Realm()
        try! realm.write{
            if let a = realm.object(ofType: Favorites.self, forPrimaryKey: storyID) {
                realm.delete(a)
            }
            else {
                realm.add(favorite)
            }

        }

    }
    

    @IBAction func viewChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            sumaryView.isHidden = false
            chapterView.isHidden = true
        case 1:
            sumaryView.isHidden = true
            chapterView.isHidden = false
        default:
            break;
        }
    }
    func autoOpenChap(_ notification: NSNotification) {

        if let chapID = notification.userInfo?["chapID"] as? Int {
            if let chapNumber = notification.userInfo?["chapNumber"] as? Int {

                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushReadVC"), object: nil, userInfo: ["chapID": chapID, "chapNumber": chapNumber])
                })
            }
        }
    }
    

}
extension MangaInfoViewController{
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
