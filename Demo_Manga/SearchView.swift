//
//  SearchView.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
enum selectScope: Int{
    case name = 0
    case author = 1
    case year = 2
}
class SearchView: UIViewController {


    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var listJSON = [MangaCollectionViewModel]()
    var genre = [String]()
    var source = ""
    var url = ""
    var listData = [MangaCollectionViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.url = String(format: urlSearchManga, UserDefaults.standard.value(forKey: "sources") as! String)
        print("url search truyen: \(self.url)")
        searchBarSetup()



    }
    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        self.listData = self.listJSON

        self.searchBar.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.endEditing(true)
    }
    func searchBarSetup(){
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name","Author","Year"]
        searchBar.tintColor  = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        searchBar.delegate = self
//        let btap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        self.tableView.isUserInteractionEnabled = true
//        self.tableView.addGestureRecognizer(btap)
//        self.view.addGestureRecognizer(btap)
//        UITapGestureRecognizer




    }
    func updateURL(url: String) {
        self.url = url
        loadUI()
    }
    func loadUI() {
        DownloadManager.shared.downloadJSONForMangaCollectionView(url: url) { (complete) in
            if self.genre.count > 0 {
                print("genre: \(self.genre.count)")
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
                print("load genre")
                self.listJSON.append(contentsOf: complete)
                self.listData = self.listJSON
                self.tableView.reloadData()
            }

            self.tableView.reloadData()
            for item in self.listJSON {
                DownloadManager.shared.downloadImage(url: item.avatarURL) { (complete) in
                    item.avatar = complete
                    self.tableView.reloadData()
                }
            }
            print("so listJSON: \(self.listJSON.count)")


        }
        
    }
}

// MARK: DATA UITABLE VIEW
extension SearchView: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listJSON == nil{
            return 0
        }
        return self.listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCellView
        cell.nameImg.image = listData[indexPath.row].avatar
        cell.name.text = listData[indexPath.row].name
        cell.author.text = listData[indexPath.row].author
        cell.year.text = listData[indexPath.row].released

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select search")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushInfoView"), object: nil, userInfo: ["storyID": listJSON[indexPath.row].id])
    }
}

// MARK -SEARCH BAR DELEGATE
extension SearchView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.tableView.reloadData()
        }else{

            filterTableView(ind: searchBar.selectedScopeButtonIndex,text: searchText)
        }
    }
    func filterTableView(ind: Int, text: String){
        switch ind{
        case selectScope.name.rawValue:
            self.listData = self.listJSON.filter({ (mod) -> Bool in
                return mod.name.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectScope.author.rawValue:
            self.listData = self.listJSON.filter({ (mod) -> Bool in
                return mod.author.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()
        case selectScope.year.rawValue:
            self.listData = self.listJSON.filter({ (mod) -> Bool in
                return mod.released.lowercased().contains(text.lowercased())
            })
            self.tableView.reloadData()

        default:
            print("no type")
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("click cho khac")
        self.searchBar.endEditing(true)

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.listData = self.listJSON
        self.searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("goi den bat dau khi cancel")
        self.searchBar.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("goi den bat cu dau khi began")
        self.searchBar.endEditing(true)
    }
    func dismissKeyboard() {
        print("dismis key")
        self.searchBar.endEditing(true)
    }
}

