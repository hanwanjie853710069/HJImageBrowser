//
//  HJImageBrowser.swift
//  HJImageBrowser
//
//  Created by 王木木 on 16/6/16.
//  Copyright © 2016年 王木木. All rights reserved.
//

import UIKit

/*
 获取高清和缩略图图片代理
 */
protocol  HJImageBrowserDelegate : NSObjectProtocol {
    
    ///  获取缩略图图片
    ///  - parameter indexRow: 当前是第几个cell
    ///  - returns: 获取的缩略图图片
    func getTheThumbnailImage(indexRow: Int) ->UIImage
    
}

class HJImageBrowser:
    UIView,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    /// 获取高清和缩略图图片代理
    var delegate :HJImageBrowserDelegate?
    
    /// 承载view  父视图view
    var bottomView:UIView!
    
    /// 是否让走预加载图片
    var isShow: Bool!
    
    /* 如果没有缩略图则显示这张图片
     如果这张图片也没有则什么也不显示
     */
    var defaultImage: UIImage!
    
    /// 当前显示的是第几张图片
    var indexImage: Int!
    
    /// 高清图片数组
    var arrayImage: [String]!
    
    //图片展示View
    var collectionView:UICollectionView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        creatUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}


extension HJImageBrowser{
    
    
    func  creatUI(){
        
        self.backgroundColor = viewTheBackgroundColor
        
        self.bottomView = UIView()
        
        isShow = false
        
        creatCollectionView()

    }
    
    func  creatCollectionView(){
    
        let fowLayout = UICollectionViewFlowLayout.init()
        
        fowLayout.minimumLineSpacing = 0;
        
        fowLayout.scrollDirection = .Horizontal
        
        fowLayout.itemSize = CGSizeMake(ScreenWidth + imageInterval,
                                        ScreenHeight)
        
        collectionView = UICollectionView.init(frame: CGRectMake(0,
            0,
            ScreenWidth + imageInterval,
            ScreenHeight),
                                               collectionViewLayout: fowLayout)
        
        collectionView.registerClass(HJCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.pagingEnabled = true
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
        collectionView.alpha = 0
        
        collectionView.backgroundColor = viewTheBackgroundColor
        
        self.addSubview(collectionView)
        
    }
    
    override func layoutSubviews(){
        
        super.layoutSubviews()
        
        if (isShow == false) {
            
            self.collectionView.contentOffset = CGPointMake((self.frame.size.width + imageInterval) *  CGFloat(self.indexImage), 0)
            
            isShow = true
            
            let  tempView = UIImageView.init()
            
            var ima = UIImage.init()
            
            self.addSubview(tempView)
            
            if ((self.delegate?.getTheThumbnailImage(self.indexImage)) != nil) {
                
                ima = (self.delegate?.getTheThumbnailImage(self.indexImage))!
                
                
            }else{
                
                if (self.defaultImage != nil) {
                    
                    ima = self.defaultImage!
                    
                }else{
                    
                    UIView.animateWithDuration(animationTime, animations: {
                        
                        tempView.center = self.center
                        
                        tempView.bounds = CGRectMake(0, 0, 300, 300)
                        
                        self.collectionView.alpha = 1
                        
                    }) { (callBack) in
                        
                        tempView.removeFromSuperview()
                        
                    }
                    
                }
                
            }
            
            tempView.image = ima
            
            
            let ve:UIView!
            
            if self.bottomView.isKindOfClass(UICollectionView.classForCoder()) {
                
                let view = self.bottomView as! UICollectionView
                
                let path = NSIndexPath.init(forRow: self.indexImage, inSection: 0)
                
                ve = view.cellForItemAtIndexPath(path)
                
            }else{
                
                ve = self.bottomView.subviews[indexImage]
            }
            
            let rect = self.bottomView.convertRect(ve.frame, toView: self)
            
            tempView.frame = rect
            
            self.collectionView.hidden = true
            
            self.collectionView.alpha = 1
            
            UIView.animateWithDuration(animationTime, animations: {
                
                tempView.center = self.center
                
                let heightS = (ima.size.height)/(ima.size.width)*ScreenWidth
                
                let widthS = (ima.size.width)/(ima.size.height)*heightS
                
                if heightS.isNaN || widthS.isNaN {
                    
                    return
                    
                }
                
                tempView.bounds = CGRectMake(0, 0, widthS, heightS)
                
            }) { (callBack) in
                
                self.collectionView.hidden = false
                
                tempView.removeFromSuperview()
                
            }
        }
    }
    
    internal func show(){
        
        let window = UIApplication.sharedApplication().keyWindow
        
        self.frame = (window?.bounds)!
        
        window?.addSubview(self)
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! HJCell
        
        cell.bottomView = self.bottomView
        
        
        if ((self.delegate?.getTheThumbnailImage(indexPath.row)) != nil) {
            
            cell.setImageWithURL(arrayImage[indexPath.row],
                                 placeholderImage:
                (self.delegate?.getTheThumbnailImage(indexPath.row))!,
                                 defaultImage:self.defaultImage)
            
        }else{
            
            if (self.defaultImage == nil) {
                
                self.defaultImage = UIImage.init()
            }
            
            cell.setImageWithURL(arrayImage[indexPath.row],
                                 placeholderImage:self.defaultImage,
                                 defaultImage:self.defaultImage)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayImage.count
        
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let firstIndexPath = self.collectionView.indexPathsForVisibleItems().first
        
        indexImage = firstIndexPath?.row
    }
    
}


@objc(HJCell)
class HJCell:
    UICollectionViewCell,
    UIScrollViewDelegate,
UIActionSheetDelegate{
    
    static let cellId = "HJCell"
    
    var BigImage: UIImageView!
    
    var BottomScroll: UIScrollView!
    
    var bottomView:UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        creatUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI(){
        
        BottomScroll = UIScrollView.init(frame: CGRectMake(0,
            0,
            ScreenWidth,
            ScreenHeight))
        
        BottomScroll.delegate = self
        
        BottomScroll.maximumZoomScale = 2.0;
        
        BottomScroll.minimumZoomScale = 1.0;
        
        BottomScroll.backgroundColor = viewTheBackgroundColor
        
        BigImage = UIImageView.init()
        
        BigImage.userInteractionEnabled = true
        
        BottomScroll.addSubview(BigImage)
        
        self.addSubview(BottomScroll)
        
        // 单击图片
        let singleTap = UITapGestureRecognizer.init(target: self,
                                                    action: #selector(self.oneTouch(_:)))
        
        // 双击放大图片
        let doubleTap = UITapGestureRecognizer.init(target: self,
                                                    action: #selector(self.twoTouch(_:)))
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(self.handleLongpressGesture(_:)))
        
        doubleTap.numberOfTapsRequired = 2
        
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        doubleTap.requireGestureRecognizerToFail(longpressGesutre)
        
        BottomScroll.addGestureRecognizer(singleTap)
        
        BottomScroll.addGestureRecognizer(doubleTap)
        
        BottomScroll.addGestureRecognizer(longpressGesutre)
        
    }
    
    internal func setImageWithURL(url:String, placeholderImage:UIImage, defaultImage:UIImage){
        
        self.setBigImageTheSizeOfThe(placeholderImage, defaultImage:defaultImage)
        
        BigImage.sd_setImageWithURL(NSURL.init(string: url),
                                    placeholderImage: placeholderImage) {[unowned self] (image, error, SDImageCacheType, NSURL) in
                                        
                                        if image == nil {
                                            self.setBigImageTheSizeOfThe(placeholderImage, defaultImage:defaultImage)
                                            return
                                            
                                        }
                                        
                                        self.setBigImageTheSizeOfThe(image, defaultImage:defaultImage)
                                        
        }
        
    }
    
    func setBigImageTheSizeOfThe(bImage:UIImage, defaultImage:UIImage){
        
        self.BottomScroll.zoomScale = 1
        
        var heightS = (bImage.size.height)/(bImage.size.width)*self.BottomScroll.frame.size.width
        
        var widthS = (bImage.size.width)/(bImage.size.height)*heightS
        
        if heightS.isNaN || widthS.isNaN {
            
            let image = defaultImage
            
            heightS = (image.size.height)/(image.size.width)*self.BottomScroll.frame.size.width
            
            widthS = (image.size.width)/(image.size.height)*heightS
            
            if heightS.isNaN || widthS.isNaN {
                
                let imageI = getColorImageWithColor(UIColor.whiteColor())
                
                heightS = (imageI.size.height)/(imageI.size.width)*self.BottomScroll.frame.size.width
                
                widthS = (imageI.size.width)/(imageI.size.height)*heightS
                
                self.BigImage.image = imageI
                
            }else{
                
                heightS = (image.size.height)/(image.size.width)*self.BottomScroll.frame.size.width
                
                widthS = (image.size.width)/(image.size.height)*heightS
                
                self.BigImage.image = image
            }
            
        }
        
        self.BigImage.frame.size = CGSizeMake(widthS, heightS)
        
        self.BigImage.center = CGPointMake(self.BottomScroll.frame.size.width*0.5,
                                           self.BottomScroll.frame.size.height*0.5)
    }
    
    //单击函数
    func oneTouch(sender: UITapGestureRecognizer){
        
        let  tempView = UIImageView.init()
        
        let imaV = sender.view?.subviews[0] as! UIImageView
        
        let ima = imaV.image
        
        tempView.image = ima
        
        self.superview?.superview?.addSubview(tempView)
        
        let ve:UIView!
        
        if self.bottomView.isKindOfClass(UICollectionView.classForCoder()) {
            
            let view = self.bottomView as! UICollectionView
            
            let path = NSIndexPath.init(forRow: self.indexPath().row, inSection: 0)
            
            ve = view.cellForItemAtIndexPath(path)
            
        }else{
             ve = self.bottomView.subviews[self.indexPath().row]
        }
        
        if ve == nil {
            
            UIView.animateWithDuration(animationTime, animations: {
                
                self.superCollectionView().alpha = 0
                
                 self.superview?.superview?.alpha = 0
                
            }) { (callBack) in
                
                self.superview?.superview?.removeFromSuperview()
                
            }
            
            return
        }

        let rect = self.bottomView.convertRect(ve.frame, toView: self)
        
        let poin = self.bottomView.convertPoint(ve.center, toView: self)
        
        let heightS = (ima?.size.height)!/(ima?.size.width)!*ScreenWidth
        
        let widthS = (ima?.size.width)!/(ima?.size.height)!*heightS
        
        tempView.frame = CGRectMake(0, 0, widthS, heightS)
        
        tempView.center = (self.superview?.superview?.center)!
        
        
        self.superCollectionView().alpha = 0.5
        
        self.superview?.superview?.backgroundColor = UIColor.clearColor()
        
        UIView.animateWithDuration(animationTime, animations: {
            
            self.superCollectionView().alpha = 0
            
            tempView.center = poin
            
            tempView.bounds = rect
            
        }) { (callBack) in
            self.superview?.superview?.removeFromSuperview()
            
        }
    }
    
    //双击函数
    func twoTouch(sender: UITapGestureRecognizer){
        
        //        let touchPoint = sender.locationInView(sender.view)
        
        let scroll =  sender.view as! UIScrollView
        
        let imageView = scroll.subviews[0]
        
        let zs = scroll.zoomScale
        
        UIView .animateWithDuration(animationTime) {
            
            scroll.zoomScale = (zs == 1.0) ? 2.0 : 1.0
            
            var heightS = imageView.frame.height
            
            var widthS = imageView.frame.width
            
            if heightS < ScreenHeight{
                heightS = ScreenHeight
            }
            
            if widthS < ScreenWidth {
                widthS = ScreenWidth
            }
            
            imageView.center = CGPointMake(widthS/2, heightS/2)
            
        }
        
        //       scroll.setContentOffset(CGPointMake(wWidth, yHeight ), animated: true)
    }
    
    //长按手势
    func handleLongpressGesture(sender : UILongPressGestureRecognizer){
        
        if (sender.state == .Began) {
            
            
            let saveImageAlt = UIActionSheet.init(title: "保存图片到本地", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "保存")
            
            saveImageAlt.showInView(self)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, willDismissWithButtonIndex buttonIndex: Int){
        
        if buttonIndex == 0 {
            
            UIImageWriteToSavedPhotosAlbum(self.BigImage.image!,
                                           self,
                                           Selector("image:didFinishSavingWithError:contextInfo:"), nil)
            
        }
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            
            let altShow =  UIAlertView.init(title: nil,
                                            message: "图片保存失败",
                                            delegate: nil,
                                            cancelButtonTitle: "确定")
            
            altShow.show()
            
            return
            
        }
        
        let altShow =  UIAlertView.init(title: nil,
                                        message: "图片保存成功",
                                        delegate: nil,
                                        cancelButtonTitle: "确定")
        altShow.show()
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return scrollView.subviews[0]
        
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        let image = scrollView.subviews[0]
        
        var heightS = scrollView.contentSize.height
        
        var widthS = scrollView.contentSize.width
        
        if scrollView.contentSize.height <  scrollView.frame.size.height{
            
            heightS = scrollView.frame.size.height
            
        }
        
        if scrollView.contentSize.width <  scrollView.frame.size.width{
            
            widthS = scrollView.frame.size.width
            
        }
        
        UIView .animateWithDuration(0.2) {
            
            image.center = CGPointMake(widthS*0.5, heightS*0.5)
            
        }
        
    }
    
    func indexPath() ->NSIndexPath{
        
        let collectionView = self.superCollectionView
        
        let indexPath = collectionView().indexPathForCell(self)
        
        return indexPath!;
        
    }
    
    func superCollectionView() ->UICollectionView{
        
        return self.findSuperViewWithClass(UICollectionView.classForCoder()) as! UICollectionView
        
    }
    
    func findSuperViewWithClass(superViewClass:AnyClass) ->UIView{
        
        var superView = self.superview
        
        var foundSuperView:UIView?
        
        while (superView != nil && foundSuperView == nil) {
            if ((superView?.isKindOfClass(superViewClass)) != nil) {
                foundSuperView = superView
            }else{
                superView = superView!.superview;
            }
        }
        
        return foundSuperView!
    }
    
}

/// Tools 工具类
import Foundation

///屏幕高度
let ScreenHeight = UIScreen.mainScreen().bounds.size.height

///屏幕宽度
let ScreenWidth = UIScreen.mainScreen().bounds.size.width

//图片与图片之间的间隔
let imageInterval = CGFloat(20)

//视图的背景颜色
let viewTheBackgroundColor = UIColor.blackColor()

let animationTime = 0.5

//通过颜色来生成一个纯色图片
func getColorImageWithColor(color:UIColor) ->(UIImage){
    
    let rect = CGRectMake(0, 0, ScreenWidth, 200)
    
    UIGraphicsBeginImageContext(rect.size);
    
    let context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    let img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}



