//
//  MangaViewController.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/4/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MangaViewController: UIViewController {


    @IBOutlet weak var pagerTabStripView: UIView!


    var vc: UIViewController!
    var searchVC: SearchView!
    var oldSources:String!
    var isFirstLaunch = true

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        let rightFilteBarButtonItem: UIBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "filter"), style: .plain, target: self, action:#selector(self.filterTapped))
        let rightSearchBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(self.searchTapped(_:)))
        self.navigationItem.setRightBarButtonItems([rightFilteBarButtonItem,rightSearchBarButtonItem], animated: true)
        let leftSourceBarButtonItem = UIBarButtonItem(title: "Source", style: .plain, target: self, action: #selector(self.sourcesTapped))
        self.navigationItem.setLeftBarButton(leftSourceBarButtonItem, animated: true)
        self.navigationItem.title = sources
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Segement_Controller")
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        print("view goi 2 lan")
        NotificationCenter.default.addObserver(self, selector: #selector(pushInfoView(_:)), name: NSNotification.Name(rawValue: "pushInfoView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pushDetail(_:)), name: NSNotification.Name(rawValue: "pushDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterChangeSources), name: NSNotification.Name(rawValue: "reloadAfterChangeSources"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchTapped(_:)), name: NSNotification.Name(rawValue: "searchView"), object: nil)
//        self.navigationController?.viewControllers
        oldSources = sources
        NotificationCenter.default.addObserver(self, selector: #selector(doneFilter(_:)), name: NSNotification.Name(rawValue: "doneFilter"), object: nil)

    }
    func reloadAfterChangeSources() {
//        self.view.remove
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        self.viewdidLoadMangage()
    }
    func viewdidLoadMangage(){
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Segement_Controller")
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        self.navigationItem.title = UserDefaults.standard.value(forKey: "sources") as! String?
        delegateMangaView = self
    }

    override func viewDidLayoutSubviews() {
//        vc.view.frame = pagerTabStripView.frame
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPagerTabStrip"), object: nil)
    }
    func filterTapped(){
        print("click bo loc")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterView") as! FilterView
        //self.present(vc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func searchTapped(_ sender: UIBarButtonItem){
//        sender.image = #imageLiteral(resourceName: "Download")

        if(oldSources != sources || isFirstLaunch){

            searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchView") as! SearchView
            searchVC.updateURL(url: String(format: urlSearchManga, UserDefaults.standard.value(forKey: "sources") as! String))
            print("update search")
            oldSources = sources
            isFirstLaunch = false
        }
        print("khogn update truyen")

        self.navigationController?.pushViewController(searchVC, animated: true)

    }
    func sourcesTapped(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SourcesView")
        //self.present(vc!, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    func pushInfoView(_ notification: NSNotification){
        print("push info")
        let vc = storyboard?.instantiateViewController(withIdentifier: "MangaInfoViewController") as! MangaInfoViewController
        if let storyID = notification.userInfo?["storyID"] as? Int{
            print("get notification: \(storyID)")
            vc.storyID = storyID

        }
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func pushDetail(_ notification: NSNotification){
        let layout = UICollectionViewFlowLayout()
        var listCollection = DetaillLIstCollectionView(collectionViewLayout: layout)

        if let feature = notification.userInfo?["subCollection"] as? CategoryCell{

            listCollection.url = feature.url
            listCollection.urlPage = feature.urlPage
            listCollection.source = feature.source
            listCollection.option = feature.listOption[feature.currentPage]
//            listCollection.listJSON = feature.TypeApp[feature.currentPage].apps!
            listCollection.listJSON = (feature.appCategory?.apps)!
            listCollection.view.backgroundColor = UIColor.white

        }
        listCollection.collectionView?.reloadData()
        self.navigationController?.pushViewController(listCollection, animated: true)


    }
    func doneFilter(_ notification: NSNotification) {

        if let filterList = notification.userInfo?["filterList"] as? [String] {
            //self.filterList = filterList
            //tự động gọi FilterResultView
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterResultView") as!FilterResultView
            vc.filterList = filterList
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                self.navigationController?.pushViewController(vc, animated: true)
            })

        }
    }


}
