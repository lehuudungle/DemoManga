//
//  Favorites.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/18/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
class Favorites: Object{
    dynamic var mangaImage: NSData!
    dynamic var name: String = ""
    dynamic var storyID: Int = 0
    override var description: String { return "Favorites {\(mangaImage), \(name), \(storyID)}" }

    override static func primaryKey() -> String? {
        return "storyID"
    }
}
