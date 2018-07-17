//
//  TableViewMangaChapter.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TableViewMangaChapter: UIView {
    var data = [ChapModel]()
    var isFromDownload = false
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "TableViewMangaChapterCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TableViewMangaChapterCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.sectionIndexBackgroundColor = .clear


    }

}

extension TableViewMangaChapter: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor(red:0.60, green:0.61, blue:0.60, alpha:1.0)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        print("data chap: \(data.count)")
        if data == nil{
            return 0
        }
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewMangaChapterCell", for: indexPath) as! TableViewMangaChapterCell
        cell.label.text = "Chap " + String(data[indexPath.section].chap)
        cell.chapID = data[indexPath.section].chapID
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFromDownload {
            let cell = tableView.cellForRow(at: indexPath) as! TableViewMangaChapterCell
            print("chap lua chon: \(data[indexPath.section].chap)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushReadVC"), object: nil, userInfo: ["chapID": data[indexPath.section].chapID, "chapNumber": data[indexPath.section].chap])
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushReadVC"), object: nil, userInfo: ["chapID": data[indexPath.section].chapID, "chapNumber": data[indexPath.section].chap])
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func reload(){
        tableView.reloadData()
    }
}

