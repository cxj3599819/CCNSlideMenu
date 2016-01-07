//
//  CCNSlideBarItem.swift
//  CCNSlideMenu
//
//  Created by zcc on 15/12/29.
//  Copyright © 2015年 CCN. All rights reserved.
//

import UIKit

protocol CCNSlideBarItemDelegate{
    func slideBarItemSelected(item:CCNSlideBarItem)
}

let DEFAULT_TITLE_FONTSIZE:CGFloat = 15 //ItemTitleFont
let DEFAULT_TITLE_SELECTED_FONTSIZE:CGFloat = 17 //SelectedItemTitleFont
let DEFAULT_TITLE_COLOR = UIColor(red: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1) //ItemTitleColor
let DEFAULT_TITLE_SELECTED_COLOR = UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 204.0/255.0, alpha: 1) //SelectedItemTitleColor
let HORIZONTAL_MARGIN:CGFloat = 10 //Item间隔

class CCNSlideBarItem: UIView {
    
    //MARK: - Public Property
    //是否为选中item
    var selected:Bool?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //标题
    var title:NSString!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //标题Font
    var itemFontSize:CGFloat!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //选中标题Font
    var selectedItemFontSize:CGFloat!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //标题Color
    var ItemColor:UIColor!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    //选中标题Color
    var selectedItemColor:UIColor!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var delegate:CCNSlideBarItemDelegate?
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置Item默认值
        self.itemFontSize = DEFAULT_TITLE_FONTSIZE
        self.selectedItemFontSize = DEFAULT_TITLE_SELECTED_FONTSIZE
        self.ItemColor = DEFAULT_TITLE_COLOR
        self.selectedItemColor = DEFAULT_TITLE_SELECTED_COLOR
        self.backgroundColor = UIColor.clearColor()
    }
    //绘制item
    override func drawRect(rect: CGRect) {
        let titleX:CGFloat = (CGRectGetWidth(self.frame) - titleSize().width) * 0.5
        let titleY:CGFloat = (CGRectGetHeight(self.frame) - titleSize().height) * 0.5
        let titleRect:CGRect = CGRectMake(titleX, titleY, titleSize().width, titleSize().height)
        let attribute = [NSFontAttributeName : titleFont(),NSForegroundColorAttributeName : titleColor()]
        self.title.drawInRect(titleRect, withAttributes: attribute)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("说点什么")
    }
    
    //MARK: - Private  (get Item相关属性)
    private func titleSize() -> CGSize{
        let attributes = [NSFontAttributeName: titleFont()]
        var size:CGSize = self.title.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT),CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        return size
    }
    
    private func titleFont() -> UIFont{
        var font:UIFont!
        if self.selected == true{
            font = [UIFont.boldSystemFontOfSize(self.selectedItemFontSize)].first
        }else{
            font = [UIFont.systemFontOfSize(self.itemFontSize)].first
        }
        return font
    }
    
    private func titleColor() -> UIColor{
        var color:UIColor!
        if self.selected == true {
            color = self.selectedItemColor
        }else{
            color = self.ItemColor
        }
        return color
    }
    
    //MARK: - Public Class Method
    func widthForTitle(title:NSString) -> CGFloat{
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(DEFAULT_TITLE_FONTSIZE)]
        var size = title.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
        size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2
        return size.width
    }
    
    //touch触发系统回调
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //设置选中，并重新绘制item
        self.selected = true
        self.delegate?.slideBarItemSelected(self)
    }
    
}
