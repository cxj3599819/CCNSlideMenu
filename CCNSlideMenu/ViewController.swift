//
//  secondViewController.swift
//  CCNSlideMenu
//
//  Created by zcc on 15/12/30.
//  Copyright © 2015年 CCN. All rights reserved.
//

import UIKit

let reuseIdentifier = "mainCell"

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    var slideBar:CCNSlideBar!
    var viewArr = [String]()
    var collectionView:UICollectionView?
    //用来存放menu 对应的控制器
    var vcArr = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
       
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.modalPresentationCapturesStatusBarAppearance = false

        self.viewArr.append("门前")
        self.viewArr.append("大桥下")
        self.viewArr.append("游过一群鸭")
        self.viewArr.append("快来快来")
        self.viewArr.append("数一数")
        self.viewArr.append("二四六七八")
        self.viewArr.append("数一数")
        
        initSlideBar()
        initCollectionView()
        getViewData()
    }
    
    func initSlideBar(){
        self.slideBar = {
            /**
             平分:Average
             滑动:Slide
             */
            let slideBar = CCNSlideBar(frame: CGRectMake(0, 0, MainWidth, 40), disPlayType: .Slide)
            slideBar.itemsTitle = self.viewArr
//            slideBar.itemColor = UIColor(red: 255.0, green: 153.0, blue: 204.0, alpha: 1)
//            slideBar.itemSelectedColor = UIColor.magentaColor()
//            slideBar.sliderColor = UIColor.magentaColor()
            return slideBar
            }()
        self.slideBar.slideBarItemSelectedCallback { (idx) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let indexPath = NSIndexPath(forItem: idx, inSection: 0)
                self.collectionView!.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
            })
            print("block 回调")
        }
        self.navigationItem.titleView = self.slideBar
    }
    
    func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        flowLayout.itemSize = CGSizeMake(MainWidth, MainHeight )
        
        let collectionView = UICollectionView(frame: CGRectMake(0, 0, MainWidth, MainHeight), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView = collectionView
        self.view.addSubview(collectionView)
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        
        //注册cell
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    //获取数据源
    func getViewData(){
        if vcArr.count == 0 {
            for item in self.viewArr{
                switch item {
                case "门前":
                    let vc = ViewController1()
                    self.vcArr.append(vc)
                    break
                case "大桥下":
                    let vc = ViewController2()
                    self.vcArr.append(vc)
                    break
                case "游过一群鸭":
                    let vc = ViewController3()
                    self.vcArr.append(vc)
                    break
                case "快来快来":
                    let vc = ViewController4()
                    self.vcArr.append(vc)
                    break
                case "数一数":
                    let vc = ViewController5()
                    self.vcArr.append(vc)
                    break
                case "二四六七八":
                    let vc = ViewController1()
                    self.vcArr.append(vc)
                    break
                case "数一数":
                    let vc = ViewController5()
                    self.vcArr.append(vc)
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Collection view data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        
        let vc = self.vcArr[indexPath.row] as UIViewController
        vc.view.frame = cell.bounds
        cell.contentView.addSubview(vc.view!)
        
        return cell
    }
    //MARK: - CollectionViewDelegate method
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let nowIndexPath: NSIndexPath? = self.collectionView!.indexPathsForVisibleItems().last
        print(nowIndexPath?.item)
        if let _  = nowIndexPath{
            self.slideBar.selectSlideBarItemAtIndex(nowIndexPath!.row)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
