//
//  MangaCollectionViewModel.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

import UIKit

class MangaCollectionViewModel {
    var id: Int
    var name: String
    var avatarURL: String
    var genre: [String]
    var avatar = UIImage()
    var author:String = ""
    var released = ""

    init(id: Int, name: String, avatarURL: String, genre: [String]) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.genre = genre
        //        DownloadManager.shared.downloadImage(url: avatarURL) { (complete) in
        //            self.avatar = complete
        //        }
    }
    func setAuthor_Released(author: String,released: String){
        self.author = author
        self.released = released
    }
}
