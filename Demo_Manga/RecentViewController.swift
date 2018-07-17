
//
//  RecentViewController.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/16/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class RecentViewController: UIViewController,GADBannerViewDelegate {

    var data = [Recent]()

    @IBOutlet weak var tableView: UITableView!
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-9163384915202343/4116857116"
        adBannerView.delegate = self
        adBannerView.rootViewController = self

        return adBannerView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationItem.title = "Recent"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        adBannerView.load(GADRequest())
       
        



    }
    override func viewDidAppear(_ animated: Bool) {
        loadDatabase()
        adBannerView.load(GADRequest())
    }


    func loadDatabase(){

        let realm = try! Realm()
        print("duong dan: \(realm.configuration.description)")
        let allRecent = realm.objects(Recent.self)
        let recentSorted = allRecent.sorted(byKeyPath: "time", ascending: false)
        data.removeAll()
        data.append(contentsOf: recentSorted)
        
        tableView.reloadData()

    }
    func dateToString(time: NSDate)->String{
        let dateFormatter = DateFormatter()
        return dateFormatter.timeSince(from: time, numericDates: true)
    }

}
extension RecentViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath)
        let image = cell.viewWithTag(100) as! UIImageView
        image.image = UIImage.init(data: data[indexPath.row].mangaImage as Data)
        let name = cell.viewWithTag(101) as! UILabel
        name.text = data[indexPath.row].name
        let chapNumber = cell.viewWithTag(103) as! UILabel
        chapNumber.text = "Chap "+String(data[indexPath.row].chap)
        let time = cell.viewWithTag(102) as! UILabel
        time.text = dateToString(time: data[indexPath.row].time)
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(realm.objects(Recent.self).filter("storyID ==%@", data[indexPath.row].storyID))
                data.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MangaInfoViewController") as! MangaInfoViewController

        vc.storyID = data[indexPath.row].storyID

        self.navigationController?.pushViewController(vc, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "autoOpenChap"), object: nil, userInfo: ["chapID": self.data[indexPath.row].chapID, "chapNumber": self.data[indexPath.row].chap])
        })
    }
}

// MARK: DELEGATE
extension RecentViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(collectionView.frame.size.width/3), height: CGFloat(collectionView.frame.width/2))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    // khoang cach giua cac cell lien tiep
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        print("Banner loaded successfully")
        tableView.tableHeaderView?.frame = bannerView.frame
        tableView.tableHeaderView = bannerView

    }

    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("Fail to receive ads")
        print(error)
    }
}
extension DateFormatter {
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).

     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month".

     - Returns: A string with formatted `date`.
     */
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)

        var result = ""

        if components.year! >= 2 {
            result = "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1 minute ago"
            } else {
                result = "A minute ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!) seconds ago"
        } else {
            result = "Just now"
        }

        return result
    }
}

