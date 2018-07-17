//
//  TableViewSource.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/14/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import M13Checkbox
class TableViewSource: UIView {
    var tableViewSource: [String : [String]]!
    var tableViewHeaders = [String]()
    var listSource = [SourcesModel]()


    @IBOutlet weak var tableView: UITableView!
    var oldCellIndexPath:IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "TableViewCellSource", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TableViewCellSource")

        tableView.delegate = self
        tableView.dataSource = self
        DownloadManager.shared.downloadSources(url: urlSources) { (complete) in
            self.listSource = complete
            self.getTableData()
            //self.capitalize()
            self.tableView.reloadData()
        }
    }


}
extension TableViewSource: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableViewSource[tableViewHeaders[section]]?.count)!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let a: String = String(tableViewHeaders[section])
        return a
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCellSource") as! TableViewCellSource
        
        cell.checkBox.stateChangeAnimation = .spiral
        cell.name.text = tableViewSource[tableViewHeaders[indexPath.section]]?[indexPath.row]
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != oldCellIndexPath && oldCellIndexPath != nil {
            let oldCell = tableView.cellForRow(at: oldCellIndexPath) as! TableViewCellSource
            oldCell.checkBox.setCheckState(.unchecked, animated: true)
        }


        let cell = tableView.cellForRow(at: indexPath) as! TableViewCellSource

        cell.checkBox.setCheckState(.checked, animated: true)

        oldCellIndexPath = indexPath

        for item in listSource {
            if item.name == tableViewSource[tableViewHeaders[indexPath.section]]?[indexPath.row] {
                //item.id
                // gọi info truyện ở đây
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeSource"), object: nil, userInfo: ["source": item.slug])
            }
        }
    }

    
}
extension TableViewSource {

    func createTableData() -> (nations: [String], source: [String : [String]]) {

        // Build Character Set
        var nation = Set<String>()

        for item in self.listSource {
            nation.insert(item.nation)
        }
        let sortedNation = nation.sorted(by: {$0 < $1})

        // Build tableSourse array
        var tableViewSourse = [String : [String]]()

        for item in nation {
            var words = [String]()
            for listSoure in self.listSource {
                if listSoure.nation == item {
                    words.append(listSoure.name)
                }
            }
            tableViewSourse[item] = words.sorted(by: {$0 < $1})
        }

        return (sortedNation, tableViewSourse)
    }

    func getTableData() {
        tableViewSource = createTableData().source
        tableViewHeaders = createTableData().nations
    }
}

