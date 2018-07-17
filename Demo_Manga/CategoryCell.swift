//
//  CategoryCell.swift
//  Test_XLPagerTabStrip
//
//  Created by Ledung95d on 8/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit




class CategoryCell: UICollectionViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    private let cellId = "appCellId"
    var TypeApp: [AppCategory] = [AppCategory(name: "Populator"),AppCategory(name: "New Manga"),AppCategory(name: "Last Update")]
    var listJSON = [MangaCollectionViewModel]()
    var genre = [String]()
    var source = "mangapark"
    var urlPage = 1
    var option = ""
    var listOption: [String] = ["popular","new","update"]
    var url = ""
    var temp = 0
    var currentPage:Int!
    var appCategory: AppCategory? {
        didSet {
            print("goi truoc")
            if let name = appCategory?.name {
                nameLabel.text = name
            }

            appsCollectionView.reloadData()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)



        settupViews()

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func updateUrlPage() {
        if urlPage > 20 {
            return
        }
//        print("update option: \(listOption[currentPage])")
        urlPage += 1
        print("currentPage: \(currentPage)")
        var urlString = String(format: urlCollectionManga, source, listOption[currentPage], urlPage)
        print("doan url: \(urlString)")
        updateURL(url: urlString)
    }
    func updateURL(url: String) {
        self.url = url
        loadUI()
        self.appsCollectionView.reloadData()
    }

    func loadUI() {
        DownloadManager.shared.downloadJSONForMangaCollectionView(url: url) { (complete) in
            print("so genre: \(self.genre.count)")
            if self.genre.count > 0 {
                print("genre: \(self.genre.count)")
                for item in complete {
                    for genreItem in item.genre {
                        if let index = self.genre.index(of: genreItem) {
                            self.listJSON.append(item)
                            self.appCategory?.apps = self.listJSON
                            break
                        }
                    }
                }
            }

            else {
                print("load genre")
                self.listJSON.append(contentsOf: complete)
                self.appCategory?.apps = self.listJSON
                print("so app: \(self.appCategory?.apps?.count)")
            }

            self.appsCollectionView.reloadData()
            for item in self.listJSON {
                DownloadManager.shared.downloadImage(url: item.avatarURL) { (complete) in
                    item.avatar = complete
                    self.appsCollectionView.reloadData()
                }
            }
            print("so listJSON: \(self.listJSON.count)")
//            if self.listJSON.count < 9 {
//                self.updateUrlPage()
//            }

        }
        
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New App"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view

    }()
    let seeAll: UIButton = {

        let button = UIButton()
        let yourAttributes : [String: Any] = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName : UIColor.black,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue]
        let attributeString = NSMutableAttributedString(string: "See All",
                                                        attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.setTitle("See All", for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func settupViews(){
        print("cel lown : \(self.frame.height)")
        backgroundColor = UIColor.clear
//        addSubview(nameLabel)
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        addSubview(seeAll)
        seeAll.addTarget(self, action: #selector(actionSeeAll), for: .touchUpInside)
        //        nameLabel.backgroundColor = UIColor.blue
        dividerLineView.backgroundColor = UIColor.brown
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": seeAll]))


//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLineView]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(16)]-16-[v0][seeAll(16)][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerLineView, "nameLabel": nameLabel,"seeAll":seeAll]))
        print("frame co:\(self.appsCollectionView.frame)")
        frameCollection = appsCollectionView.frame
//        self.appsCollectionView.reloadData()

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.appCategory?.apps?.count{
            return count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        print("cell con height: \(cell.frame.height)")
        cell.app = appCategory?.apps?[indexPath.item]
//        currentPage = indexPath.item
        print("doi tuong cell moi : \(cell.app?.name)")

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("frame height : \(frame.height)____\(frame.width)")
        return CGSize(width: 100, height: frame.height-48.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0,14)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        scrollView.
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            updateUrlPage()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select row")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushInfoView"), object: nil, userInfo: ["storyID": self.appCategory?.apps?[indexPath.row].id])
        print("did select row sau")


    }
    func actionSeeAll(){
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushDetail"), object: nil, userInfo: ["subCollection":self])
    }


}


class AppCell: UICollectionViewCell{


    var app: MangaCollectionViewModel?{
        didSet{
            if let name = app?.name {
                nameLable.text = name
//                nameLable.setNeedsLayout()

                print("name: \(name)")

                nameLable.frame = CGRect(x: 0, y: frame.width + 5, width: frame.width, height: 40)
                nameLable.sizeToFit()

            }


            if let imageName = app?.avatar {
                print("doi tuong image: \(imageName)")
                imageView.image = imageName
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let nameLable: UILabel = {
        let label = UILabel()
        label.text = "disney land"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
    }()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "frozen")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    func setupViews(){
        self.backgroundColor = UIColor.white
        addSubview(imageView)
        addSubview(nameLable)
        print("appcell frame : \(self.frame)")
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLable.frame = CGRect(x: 0, y: frame.width+2, width: frame.width, height: 40)

    }

}
