//
//  DownloadModel.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/15/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Download: Object {
    dynamic var mangaImage: NSData!
    dynamic var name: String = ""
    dynamic var storyID: Int = 0

    //mangaInfo
    dynamic var author: String!
    dynamic var genre: String!
    dynamic var describe: String!
    dynamic var updateAt: String!
    dynamic var status: String!
    dynamic var total: Int = 0

    var chap = List<ChapDownloadModel>()


    override var description: String { return "Download {\(mangaImage), \(name), \(storyID), \(author), \(genre), \(describe), \(updateAt), \(status), \(total), \(chap)}" }

    override static func primaryKey() -> String? {
        return "storyID"
    }
}
class ChapDownloadModel: Object {
    dynamic var chapID: Int = 0
    dynamic var chap: Double = 0
    var chapImage = List<ChapImageModel>()

    override var description: String { return "ChapDownloadModel {\(chapID), \(chap), \(chapImage)}" }

    override static func primaryKey() -> String? {
        return "chapID"
    }
}
class ChapImageModel: Object {
    dynamic var chapImage: NSData!

    override var description: String { return "ChapImageModel {\(chapImage)}" }
}
