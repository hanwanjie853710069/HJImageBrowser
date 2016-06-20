//
//  ViewController.swift
//  HJImageBrowser
//
//  Created by 王木木 on 16/6/15.
//  Copyright © 2016年 王木木. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    HJImageBrowserDelegate{
    
    var dataArray = ["http://p2.qhimg.com/t011fc13354f12d1a46.jpg",
                     "http://img.bimg.126.net/photo/Q_YgZ2eYuC1qtuBXeAFMXQ==/1457758904385917359.jpg",
                     "http://img.taopic.com/uploads/allimg/140714/234975-140G4155Z571.jpg",
                     "http://image.tianjimedia.com/uploadImages/2012/233/37/HF17SP1LG9QQ.jpg",
                     "http://pic23.nipic.com/20120908/3073979_090316421000_2.jpg",
                     "http://image.tianjimedia.com/uploadImages/2015/129/56/J63MI042Z4P8.jpg",
                     "http://image.tianjimedia.com/uploadImages/2012/233/26/QNK85ZK47V2R.jpg",
                     "http://n.7k7kimg.cn/2015/0723/1437613406241.jpg",
                     "http://image.tianjimedia.com/uploadImages/2011/361/KD85LY2UE08Q.jpg",
                     "http://img.taopic.com/uploads/allimg/120425/95478-12042511120249.jpg",
                     "http://v1.qzone.cc/pic/201306/29/17/10/51cea48cb4d54713.jpg%21600x600.jpg"]
    
    lazy var collectionView:UICollectionView = {
        
        let fowLayout = UICollectionViewFlowLayout.init()
        
        fowLayout.itemSize = CGSizeMake(ScreenWidth/4,
                                        ScreenWidth/4)
        
        fowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        let collect = UICollectionView.init(frame: CGRectMake(0,
            0,
            ScreenWidth,
            ScreenHeight),
                                            collectionViewLayout: fowLayout)
        
        collect.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        collect.delegate = self
        
        collect.dataSource = self
        
        return collect
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dataArray = dataArray + dataArray + dataArray
        
        self.collectionView.backgroundColor = UIColor.darkGrayColor()
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        self.view.addSubview(collectionView)
    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath)
        
        let imagea = UIImageView.init()
        
        imagea.frame = cell.bounds
        
        imagea.sd_setImageWithURL(NSURL.init(string: self.dataArray[indexPath.row]),
                                  placeholderImage: getColorImageWithColor())
        
        cell.addSubview(imagea)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let bview = HJImageBrowser()
        
        bview.delegate = self
        
        bview.bottomView = self.collectionView
        
        bview.indexImage = indexPath.row
        
        bview.defaultImage = getColorImageWithColor()
        
        bview.arrayImage = dataArray
        
        bview.show()
        
    }
    
    func getTheThumbnailImage(indexRow: Int) -> UIImage {
        
        let indexPath = NSIndexPath.init(forRow: indexRow, inSection: 0)
        
        let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
        
        if cell == nil {
            
            return getColorImageWithColor()
            
        }
        
        var imagV = UIImageView()
        
        for temp in (cell?.subviews)! {
            
            if temp.isKindOfClass(UIImageView.classForCoder()) {
                
                imagV = temp as! UIImageView
                
            }
            
        }
        
        return imagV.image!
    }
    
}

