//
//  Extension.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/3/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit
let urlMANGAInfo = "http://45.32.225.81/getmangainfo?story_id=%d&user_id=5333"
let urlCollectionManga = "http://45.32.225.81/getstoryoption?version_app=v1.1&source=%@&limit=10&option=%@&page=%d"
let urlSources = "http://45.32.225.81/api/sources?version_app=v1.1"
let urlChapter = "http://45.32.225.81/getchapterinfo?chapter_id=%d"
let urlSearchManga = "http://45.32.225.81/getstoryoption?version_app=v1.1&source=%@&limit=4000"
var frameCollection = CGRect()

extension Character {
    var asciiValue: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}
extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
var sources = "mangatube"
var delegateMangaView: MangaViewController!
