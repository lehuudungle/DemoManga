//
//  SourcesView.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SourcesView: UIViewController {

    var source = ""
    @IBOutlet var tableViewView: UIView!
    var tableView: TableViewSource!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = Bundle.main.loadNibNamed("TableViewSource", owner: nil, options: nil)?.first as! TableViewSource
        let rightDoneBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        self.navigationItem.setRightBarButton(rightDoneBarButtonItem, animated: true)

        let leftCancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelTapped))
        self.navigationItem.setLeftBarButton(leftCancelBarButtonItem, animated: true)

        self.navigationItem.title = "Source & Language"
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeSource(_:)), name: NSNotification.Name(rawValue: "changeSource"), object: nil)
    }
    func changeSource(_ notification: Notification){
        if let source = notification.userInfo?["source"] as? String{
            self.source = source
            print("source code: \(source)")
        }
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = self.tableViewView.frame
    }

    override func viewDidAppear(_ varmated: Bool) {

        //self.collectionView.collectionView.reloadData()
        self.view.addSubview(self.tableView) // view tổng (view đầu tiên, có sẵn trong ViewController)
    }

    func doneTapped(){
        if source == "" {
            return
        }

        if source != sources {
            let defaults = UserDefaults.standard
            defaults.set(source, forKey: "sources")
            sources = source
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAfterChangeSources"), object: nil)

//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAfterChangeSources"), object: nil, userInfo: <#T##[AnyHashable : Any]?#>)
            self.navigationController?.popViewController(animated: true)
        }

    }
    func cancelTapped(){
        self.navigationController?.popViewController(animated: true)

    }

   

}
