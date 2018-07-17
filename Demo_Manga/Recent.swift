//
//  Recent.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/15/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Recent: Object {
    dynamic var mangaImage: NSData!
    dynamic var time = NSDate()
    dynamic var name: String = ""
    dynamic var chap: Double = 0
    dynamic var chapID: Int = 0
    dynamic var storyID: Int = 0

    override var description: String { return "Recent {\(mangaImage), \(time), \(name), \(chap), \(chapID), \(storyID)}" }

    override static func primaryKey() -> String? {
        return "storyID"
    }
}
