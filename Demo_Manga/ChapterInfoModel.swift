//
//  ChapterInfoModel.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/15/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class ChapterInfoModel {
    var listImgURL = [String]()
    init() {

    }

    init(listImgURL: [String], chap: Int) {
        self.listImgURL = listImgURL
    }
}

