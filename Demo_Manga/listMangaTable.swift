//
//  listMangaTable.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/9/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class listMangaTable: UITableViewController {

    var tableViewSource: [Character : [String]]!
    var tableViewHeaders = [Character]()
    var arrayKey: NSArray!
    var arrayData: NSMutableArray!
    var dictContacts = NSMutableDictionary()

    var data = [String]()
    var idData = [String]()
    var dictManga = NSMutableDictionary()
    var listJSON = [MangaTableViewModel]()

    var url = ""

    var searchValue = ""
        
    override func viewDidLoad() {

        super.viewDidLoad()
        print("goi list")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "listMangaCellTalbe", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "listMangaCellTalbe")

    }
    
    func updateURL(url: String) {
        self.url = url
        getJSON()
    }

    func getJSON() {
        DownloadManager.shared.downloadJSONForMangaTableView(url: url) { (complete) in
            self.listJSON.append(contentsOf: complete)
            //            self.listJSON = complete
            print("url manga fox: \(self.url)")
                        print("danh sach list truyen trong\(self.listJSON.count)")

            self.reloadData()
        }
    }

    func reloadData() {
        //        print("so list JSon lan 2: \(self.listJSON.count)")
        for item in listJSON {
            data.append(item.name)
            dictManga[item.name] = item.id

        }
        //        print("so list dictionManga: \(dictManga.allKeys.count)")
        getTableData(dictionManga: dictManga)

        tableView.reloadData()
    }

    func search(text: String) {
        searchValue = text
        reloadData()
    }


    // hien thi background cua table
     override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     cell.backgroundColor = UIColor.white
     }
    // hien thi mau cua cac section
     override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
     let header = view as! UITableViewHeaderFooterView
     header.textLabel?.textColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
     }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if arrayKey==nil{
            return 0
        }
        return arrayKey.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if arrayKey == nil{
            return 0
        }
        let sectionTitle = arrayKey[section]
        print("so count: \((dictContacts[sectionTitle as! String] as! AnyObject).count)")
        return (dictContacts[sectionTitle as! String] as! AnyObject).count


    }

    // hien thi title section
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

     return arrayKey[section] as! String
     }
// hien thi title ben phai vaf doi mau cho cac section
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        self.tableView.sectionIndexColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        return arrayKey as? [String]
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = tableView.dequeueReusableCell(withIdentifier: "listMangaCellTalbe", for: indexPath) as! listMangaCellTalbe



         let sectionTitle = arrayKey[indexPath.section]
         let sectionNameMange = dictContacts[sectionTitle as! String] as! [AnyObject]
         cell.name.text = (sectionNameMange as! [AnyObject])[indexPath.row] as! String

         print("cell.nam: \(cell.name.text)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadPagerTabStrip"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopActivityView"), object: nil)

         return cell


    }

     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let cell = tableView.cellForRow(at: indexPath) as! listMangaCellTalbe

     let sectionTitle = arrayKey[indexPath.section]
     let sectionNameMange = dictContacts[sectionTitle as! String]
     let nameManga: String = (sectionNameMange as! [AnyObject])[indexPath.row] as! String
     print("itemID: \(dictManga[nameManga] as! Int)")
     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushInfoView"), object: nil, userInfo: ["storyID":dictManga[nameManga] as! Int])

     }



    func createTableData(wordList: [String]) -> (firstSymbols: [Character], source: [Character : [String]]) {

        // Build Character Set
        var firstSymbols = Set<Character>()
        //        var i = 0
        func getFirstSymbol(word: String) -> Character {
            var a = word[word.startIndex]
            if a.asciiValue <= 64 ||
                (91 <= a.asciiValue && a.asciiValue <= 96) ||
                (a.asciiValue >= 123){
                a = "#"
            }
            if 97 <= a.asciiValue && a.asciiValue <= 122 {
                a = Character(String(a).uppercased())
            }
            return a
        }

        wordList.forEach {
            _  = firstSymbols.insert(getFirstSymbol(word: $0))
        }

        // Build tableSourse array
        var tableViewSourse = [Character : [String]]()

        for symbol in firstSymbols {

            var words = [String]()

            for word in wordList {
                if symbol == getFirstSymbol(word: word) {
                    words.append(word)
                }
            }

            tableViewSourse[symbol] = words.sorted(by: {$0 < $1})
        }

        let sortedSymbols = firstSymbols.sorted(by: {$0 < $1})

        return (sortedSymbols, tableViewSourse)
    }

    func createDataTable(words: [String]){
        for ele in words{
            var firstCharacter:String  = (ele as! NSString).substring(to: 1)

            var character = Character(firstCharacter)

            if (97 <= character.asciiValue && character.asciiValue <= 122) || (65 <= character.asciiValue && character.asciiValue <= 90){
                firstCharacter = firstCharacter.uppercased()
            }else{
                firstCharacter = "#"
            }
            var arrayForWord: NSMutableArray!
            if(dictContacts.value(forKey: firstCharacter) != nil){
                arrayForWord = dictContacts.value(forKey: firstCharacter) as! NSMutableArray
                arrayForWord.add(ele)
                dictContacts.setValue(arrayForWord, forKey: firstCharacter)
                //                print("bi nill")
            }else{
                arrayForWord = NSMutableArray()
                arrayForWord.add(ele)
                //                arrayForWord = NSMutableArray(object: ele)
                dictContacts.setValue(arrayForWord, forKey: firstCharacter)
                //                print("no nill nhe")
            }
        }


        arrayKey = dictContacts.allKeys as! [String] as NSArray!
        arrayKey = arrayKey.sortedArray(using: "compare:") as! NSMutableArray
        //        self.listTable.reloadData()
        self.tableView.reloadData()


    }

    func getTableData(dictionManga: NSMutableDictionary) {
        print("tu : \(dictionManga.allKeys.count)")
        createDataTable(words: dictionManga.allKeys as! [String])
        self.tableView.reloadData()
    }
     



    
}
