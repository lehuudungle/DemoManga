//
//  MangaInfoModel.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class MangaInfoModel{
    var id: Int!
    var name: String!
    var avatarURL: String!
    var author: [String]!
    var genre: String!
    var describe: String!
    var updateAt: String!
    var status: String!
    var total: Int!
    var chaps: [ChapModel]!
    init() {

    }
    init(id: Int, name: String,avatarURL: String,author: [String],genre: String,describe: String,updateAt: String, status: String!,total: Int,chaps: [ChapModel]) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.author = author
        self.genre = genre
        self.describe = describe
        self.updateAt = updateAt
        self.status = status
        self.total = total
        self.chaps = chaps
        
    }
}

class ChapModel{
    var chapID: Int!
    var vol: String!
    var chap: Double!

    init() {

    }
    init(chapID: Int, vol: String,chap: Double) {
        self.chapID = chapID
        self.vol = vol
        self.chap = chap
    }
}
