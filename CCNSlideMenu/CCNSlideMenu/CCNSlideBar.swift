//
//  CCNSlideBar.swift
//  CCNSlideMenu
//
//  Created by zcc on 15/12/29.
//  Copyright © 2015年 CCN. All rights reserved.
//

import UIKit

enum DisplayType{//显示风格
    case Average
    case Slide
}

typealias CCNSlideBarItemSelectedCallback = (idx:NSInteger)->Void

let MainWidth = UIScreen.mainScreen().bounds.width
let MainHeight = UIScreen.mainScreen().bounds.height
let DEFAULT_SLIDER_COLOR = UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 204.0/255.0, alpha: 1)
let SLIDER_VIEW_HEIGHT:CGFloat = 2

class CCNSlideBar: UIView,CCNSlideBarItemDelegate{
  
    //MARK: - Public Property
    //ItemTitleArr
     var itemsTitle:[String]?{
        didSet{
            if self.itemsTitle != nil && self.itemsTitle?.count > 0{
                steupItems()
            }
        }
    }
    
    //ItemTitleColor
    var itemColor:UIColor!{
        didSet{
            if let _ = self.items{
                for item in self.items!{
                    item.ItemColor = itemColor
                }
            }
        }
    }
    
    //ItemSelectedTieleColor
    var itemSelectedColor:UIColor!{
        didSet{
            if let _ = self.items{
                for item in self.items!{
                    
                    item.selectedItemColor = itemSelectedColor
                }
            }
        }
    }
    
    //(底部)滑动条的颜色
    var sliderColor:UIColor!{
        didSet{
            self.sliderView.backgroundColor = self.sliderColor
        }
    }
    
    //MARK: - Private
    private var scrollView:UIScrollView!
    
    //ItemArr
    private var items:[CCNSlideBarItem]!
    
    //(底部)滑动条
    private var sliderView:UIView!
    
    //SelectedItem
    private var selectedItem:CCNSlideBarItem!{
        willSet{
            if let _ = self.selectedItem{
                selectedItem.selected = false
            }
        }
    }
    
    //block回调
    private var callback:CCNSlideBarItemSelectedCallback!
    
    //设置item的显示风格(平分:Average/滑动:Slide)
    private var disPlayType:DisplayType = .Slide
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initScrollView()
        initSliderView()
    }
    
    convenience init(frame: CGRect,disPlayType:DisplayType) {
        self.init(frame:frame)
        self.disPlayType = disPlayType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    //MARK: - Public Class Method
    func slideBarItemSelectedCallback(callback:CCNSlideBarItemSelectedCallback){
        self.callback = callback;
    }
    
    func selectSlideBarItemAtIndex(index:NSInteger){
        let item:CCNSlideBarItem = self.items![index]
        if item == self.selectedItem {
            return
        }
        item.selected = true
       
        scrollToVisibleItem(item)
        addAnimationWithSelectedItem(item)
        self.selectedItem = item
    }
    
    //MARK: - Private Class Method
    private func initScrollView(){
        self.scrollView = {
            let scroll = UIScrollView(frame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            scroll.backgroundColor = UIColor.whiteColor()
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false
            scroll.bounces = false
            return scroll
        }()
        addSubview(self.scrollView)
    }
    
    private func initSliderView(){
        self.sliderView = {
            let sliderView = UIView()
            sliderView.backgroundColor = DEFAULT_SLIDER_COLOR
            return sliderView
        }()
        self.scrollView.addSubview(self.sliderView)
    }
    
    private func steupItems(){
        var itemX:CGFloat = 0
        self.items = [CCNSlideBarItem]()
        
        for title in self.itemsTitle!{
            let item = CCNSlideBarItem()
            var itemW:CGFloat
            switch disPlayType {
            case .Slide:
                itemW = item.widthForTitle(title)
                break
            case .Average:
                itemW = UIScreen.mainScreen().bounds.width/CGFloat(self.itemsTitle!.count) - 6
                break
            }
            item.frame = CGRectMake(itemX, 0, itemW, 40)
            item.title = title
            item.delegate = self
            self.items.append(item)
            self.scrollView.addSubview(item)
            itemX = CGRectGetMaxX(item.frame)
        }
        self.scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(self.scrollView.frame))
        let firstItem:CCNSlideBarItem = self.items!.first!
        firstItem.selected = true
        self.selectedItem = firstItem
        
        self.sliderView.frame = CGRectMake(0, self.frame.size.height - SLIDER_VIEW_HEIGHT, firstItem.frame.size.width, SLIDER_VIEW_HEIGHT);

    }
    
    private func scrollToVisibleItem(item:CCNSlideBarItem){
        let selectedItemIndex:NSInteger = self.items!.indexOf(self.selectedItem)!
        let visibleItemIndex:NSInteger = self.items!.indexOf(item)!
        if selectedItemIndex == visibleItemIndex {
            return
        }
        var offset:CGPoint = self.scrollView.contentOffset
        
        if CGRectGetMinX(item.frame) > offset.x && CGRectGetMaxX(item.frame) < (offset.x + CGRectGetWidth(self.scrollView.frame)) {
            return
        }
        if selectedItemIndex < visibleItemIndex {
            if CGRectGetMaxX(self.selectedItem.frame) < offset.x{
                offset.x = CGRectGetMinX(item.frame)
            }else{
                offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(self.scrollView.frame)
            }
        }else{
            if (CGRectGetMinX(self.selectedItem.frame) > (offset.x + CGRectGetWidth(self.scrollView.frame))) {
                offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(self.scrollView.frame);
            } else {
                offset.x = CGRectGetMinX(item.frame);
            }
        }
        
        self.scrollView.contentOffset = offset;
    }
    
    private func addAnimationWithSelectedItem(item:CCNSlideBarItem){
        let dx:CGFloat = CGRectGetMidX(item.frame) - CGRectGetMidX(self.selectedItem.frame)
        //滑动
        let positionAnimation = CABasicAnimation(keyPath: "position.x")
        positionAnimation.fromValue = self.sliderView.layer.position.x
        positionAnimation.toValue = self.sliderView.layer.position.x + dx
        //滑块长度
        let boundsAnimation = CABasicAnimation(keyPath:"bounds.size.width")
        boundsAnimation.fromValue = CGRectGetWidth(self.sliderView.layer.bounds)
        boundsAnimation.toValue = CGRectGetWidth(item.frame)
        //动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [positionAnimation]
        animationGroup.repeatCount = 1
        animationGroup.duration = 0.2
        animationGroup.delegate = self
        
        self.sliderView.layer.addAnimation(animationGroup, forKey: "basic")
        self.sliderView.layer.position = CGPointMake(self.sliderView.layer.position.x + dx, self.sliderView.layer.position.y)
        var rect:CGRect = self.sliderView.layer.bounds
        rect.size.width = CGRectGetWidth(item.frame)
        self.sliderView.layer.bounds = rect
    }
    
    //MARK: - CCNSliderBarItemDelegate
    func slideBarItemSelected(item:CCNSlideBarItem){
        if item == self.selectedItem {
            return
        }
        self.addAnimationWithSelectedItem(item)
        self.selectedItem = item
        self.callback(idx: self.items!.indexOf(item)!)
    }
    
}
