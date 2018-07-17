//
//  DownloadManager.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/3/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import ReachabilitySwift
class DownloadManager{
    static let shared = DownloadManager()


    func downloadJSONForMangaTableView(url: String, completed: @escaping(_ complete: [MangaTableViewModel]) -> Void) {

        guard let genreUrl = URL(string: url) else {
            return
        }

        let reachability = Reachability()
        reachability?.whenReachable = { reachability in


            Alamofire.request(genreUrl).responseJSON { (response) in

                if let value = response.result.value {
                    let json = JSON(value)

                    guard let content = json["content"].array else {
                        return
                    }

                    var listTableViewModel = [MangaTableViewModel]()
                    for item in content {
                        let id = item["id"].int
                        let name = item["name"].string
//                        print("name Table: \(name)")
                        if name != "" {
                            listTableViewModel.append(MangaTableViewModel(id: id!, name: name!))
                        }

                    }
                    completed(listTableViewModel)
                }

            }

        }

        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("not connect")
            }
        }

        try! reachability?.startNotifier()
        
    }
    func downloadMangaInfo(url: String, completed: @escaping(_ complete: MangaInfoModel) -> Void) {
        print("CHAP INFO: \(url)")
        guard let genreUrl = URL(string: url) else {
            return
        }

        let reachability = Reachability()
        reachability?.whenReachable = { reachability in

            Alamofire.request(genreUrl).responseJSON { (response) in

                if let value = response.result.value {
                    let json = JSON(value)

                    let content = json["content"]

                    //                    var info = MangaInfoModel()

                    let id = content["id"].int
                    let name = content["name"].string
                    let avatarURL = content["avatar"].string
                    print("va")

                    let authors = content["author"].array
                    var authorList = [String]()
                    for item in authors! {
                        let author = item.string
                        authorList.append(author!)
                    }

                    let genres = content["genre"].array
                    let genre = genres?[0].string

                    var describe = content["describe"].string
                    let updateAt = content["update_at"].string
                    let status = content["status"].string
                    let total = content["chaps"].array?.count

                    var chaps = [ChapModel]()
                    let chapArray = content["chaps"].array
                    for item in chapArray! {
                        let chapID = item["id"].int
                        var vol = item["vol"].string
                        if vol == nil {
                            vol = ""
                        }

                        var chap = item["chap"].double
                        if(chap==nil){
                            var chapString = item["chap"].string
                            let index = chapString?.index((chapString?.endIndex)!, offsetBy: -1)

                            chap = Double((chapString?.substring(to: index!))!)! + 0.1

                        }


                        chaps.append(ChapModel(chapID: chapID!, vol: vol!, chap: chap!))
                    }
                    chaps.sort{$0.chap < $1.chap}

                    if describe == nil{
                        describe = "No Describe"
                    }

                    let info = MangaInfoModel(id: id!, name: name!, avatarURL: avatarURL!, author: authorList, genre: genre!, describe: describe!, updateAt: updateAt!, status: status!, total: total!, chaps: chaps)

                    completed(info)
                }


            }

        }

        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("not connect")
            }
        }

        try! reachability?.startNotifier()
        
    }
    func downloadImage(url: String, completed: @escaping(_ image: UIImage) -> Void) {

        let reachability = Reachability()
        reachability?.whenReachable = { reachability in

            Alamofire.request(url).responseImage { (response) in
                if let image = response.result.value {
                    completed(image)
                }
            }
        }

        reachability?.whenUnreachable = { reachability in
            print("not connect")
        }

        try! reachability?.startNotifier()
    }
    func downloadJSONForMangaCollectionView(url: String, completed: @escaping(_ complete: [MangaCollectionViewModel]) -> Void) {

        guard let genreUrl = URL(string: url) else {
            return
        }
        print("search gereUrl: \(genreUrl)")
        let reachability = Reachability()
        reachability?.whenReachable = { reachability in

            Alamofire.request(genreUrl).responseJSON { (response) in

                if let value = response.result.value {
                    let json = JSON(value)

                    guard let content = json["content"].array else {
                        return
                    }

                    var listCollectionViewModel = [MangaCollectionViewModel]()
                    for item in content {
                        let id = item["id"].int
                        let name = item["name"].string
                        let avatar = item["avatar"].string
                        let genreArray = item["genre"].array
                        var author = item["artist"].array
                        var released = item["released"].string
                        print("release ben trong: \(item["released"].string)")
                        var genres:String!
                        genres = (genreArray?.count == 0) ? "" : genreArray?[0].string
                        let genre = genres?.components(separatedBy: " ")
                        print("genre collection: \(genre)")
                        print("author nil: \(author)")
                        if(author?.count==0){
                            print("bi nill author")
                            author = [JSON]()
                            author?.append("No author")

                        }
                        if(released==nil || released==""){
                            released = "No Year"
                        }
                        var MangaCollect = MangaCollectionViewModel(id: id!, name: name!, avatarURL: avatar!, genre: genre!)

                        print("release: \(released)")
                        print("author: \(author?.first?.string)")

                       
                        MangaCollect.setAuthor_Released(author: (author?.first?.string)!, released: released!)
                        listCollectionViewModel.append(MangaCollect)
                    }
                    completed(listCollectionViewModel)
                }

            }

        }

        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("not connect")
            }
        }

        try! reachability?.startNotifier()

    }
    func downloadSources(url: String, completed: @escaping(_ complete: [SourcesModel]) -> Void) {
        guard let genreUrl = URL(string: url) else {
            return
        }

        let reachability = Reachability()
        reachability?.whenReachable = { reachability in

            Alamofire.request(genreUrl).responseJSON { (response) in

                if let value = response.result.value {
                    let json = JSON(value)

                    guard let content = json["content"].array else {
                        return
                    }

                    var listSource = [SourcesModel]()
                    for item in content {
                        let name = item["name"].string
                        let slug = item["slug"].string
                        let nation = item["nation"].string
                        listSource.append(SourcesModel(name: name!, slug: slug!, nation: nation!))
                    }
                    completed(listSource)
                }

            }

        }

        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("not connect")
            }
        }

        try! reachability?.startNotifier()
    }
    func downloadChapterInfo(url: String, completed: @escaping(_ complete: ChapterInfoModel) -> Void) {

        guard let genreUrl = URL(string: url) else {
            return
        }

        let reachability = Reachability()
        reachability?.whenReachable = { reachability in

            Alamofire.request(genreUrl).responseJSON { (response) in

                if let value = response.result.value {
                    let json = JSON(value)

                    let content = json["content"]

                    guard let content2 = content["content"].array else {
                        return
                    }

                    let chapterInfo = ChapterInfoModel()
                    var stringArray = [String]()
                    for item in content2 {
                        stringArray.append(item.string!)
                    }
                    chapterInfo.listImgURL = stringArray
                    completed(chapterInfo)
                }


            }

        }

        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("not connect")
            }
        }

        try! reachability?.startNotifier()

    }
    
}
