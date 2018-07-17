//
//  FilterView.swift
//  Demo_Manga
//
//  Created by Ledung95d on 8/21/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import TagListView

class FilterView: UIViewController,TagListViewDelegate {

    let tags = ["Completed", "Action", "Adventure", "Adult", "Comedy", "Cooking", "Drama", "Fantasy", "Josei", "Martial Arts", "Mature", "Mecha", "Mystery", "Music", "One Shot", "Psychological", "Romance", "Sci-Fi", "Seinen", "Shoujo", "School Life", "Shounen", "Slice Of Life", "Sports", "Supernatural", "Ecchi", "Shounen Ai", "Shoujo Ai", "Smut", "Tragedy", "Webtoon", "Yaoi", "Yuri", "4 Koma", "Doujunshi"]
    var tagSelecteds = [String]()
    @IBOutlet weak var tagListView: TagListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tagListView.delegate = self
        let rightDoneBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        self.navigationItem.setRightBarButton(rightDoneBarButtonItem, animated: true)
        let leftCancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelTapped))
        self.navigationItem.setLeftBarButton(leftCancelBarButtonItem, animated: true)

        self.navigationItem.title = "Manga Filter"
        self.tagListView.addTags(tags)
        tagListView.textFont = UIFont.systemFont(ofSize: 20)
        tagListView.shadowRadius = 2
        tagListView.shadowOpacity = 0.4
        tagListView.shadowColor = .clear
        tagListView.shadowOffset = CGSize(width: 1, height: 1)
        tagListView.alignment = .left

        tagListView.tagBackgroundColor = .clear
        tagListView.textColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        tagListView.borderColor = UIColor(red:0.56, green:0.59, blue:0.62, alpha:1.0)
        tagListView.borderWidth = 1.0

        tagListView.backgroundColor = UIColor.white
        tagListView.cornerRadius = 4
        tagListView.marginX = 7
        tagListView.marginY = 7

        tagListView.tagSelectedBackgroundColor = UIColor(red:0.17, green:0.52, blue:0.82, alpha:1.0)
        
    }
    func doneTapped(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doneFilter"), object: nil, userInfo: ["filterList": tagSelecteds])
    }
    func cancelTapped(){
        self.navigationController?.popViewController(animated: true)

    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected

        if let index = tagSelecteds.index(of: title){
            tagSelecteds.remove(at: index)
        }else{
            tagSelecteds.append(title)
        }
    }



}
