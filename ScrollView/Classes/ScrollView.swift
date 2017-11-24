//
//  ScrollView.swift
//  EAppleNFB
//
//  Created by Eric-Ingram on 2017/8/28.
//  Copyright © 2017年 Eapple. All rights reserved.
//

import UIKit

// MARK:- Defination
@objc
protocol ScrollViewDelegate : class
{
    @objc optional func  ge_scrollViewWillBeginDragging(_ scrollView : ScrollView)
    
    @objc optional func  ge_scrollViewDidScroll(_ scrollView:ScrollView)
    
    @objc optional func  ge_scrollViewDidEndDragging(_ scrollView : ScrollView , willDecelerate decelerate:Bool)
    
    
    @objc optional func ge_scrollViewDidScrollingAnimation(_ scrollView:ScrollView)
    
    @objc optional func ge_scrollViewDidEndDecelerating(_ scrollView:ScrollView)
    
    
}

class ScrollView: UIView {
    
    
    /// 如果分页,那么会调用如下方法
    var scrollToPage : ((ScrollView.Page)->())?
    
    weak var delegate : ScrollViewDelegate?
    
    var direction : Direction = .horizontal
    
    var pageEnable = true
    var bounces = true
    
    var sensibility : ScrollSensibility = .default
    
    var duration : TimeInterval = 0.5
    
    
    
    private (set) var contentSize:CGSize
    private(set) var contentView : UIView!
    private (set) var panGesture : UIPanGestureRecognizer!
    private var startPoint : CGPoint?
    
    
    init(frame: CGRect , contentSize:CGSize) {
        
        self.contentSize = contentSize
        
        super.init(frame: frame)
        
        config()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ScrollView{
    
    
    enum Direction {
        /// 任意方向
        //        case any
        /// 水平
        case horizontal
        /// 垂直
        case vertical
    }
    
    
    struct Page {
        let x : Int
        let y : Int
    }
    
    enum ScrollSensibility:CGFloat {
        case `default`  = 600.0
        case active     = 300.0
        case lazy       = 800.0
    }
    
    
    
}

// MARK:- Config UI
extension ScrollView{
    
    
    fileprivate func config(){
        
        //        clipsToBounds = true
        backgroundColor = UIColor.clear
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        panGesture.maximumNumberOfTouches = 1
        contentView.addGestureRecognizer(panGesture)
        
    }
    
}

// MARK:- Open API
extension ScrollView{
    
    
    func addChildView(_ view:UIView, index:Int)  {
        
        contentView.addSubview(view)
        
        switch direction{
        case .horizontal:
            view.frame = CGRect(x: index.cgfloat * frame.width, y: 0, width: frame.width, height: frame.height)
        case .vertical:
            view.frame = CGRect(x: 0, y: index.cgfloat * frame.height, width: frame.width, height: frame.height)
            
        }
        //        view.frame =
    }
    
    /// 手动设置scroll到某个范围
    ///
    /// - Parameters:
    ///   - offset: offset
    ///   - animated: 是否需要动画
    func setContentOffset(offset:CGPoint,animated:Bool){
        
        var rect = contentView.frame
        
        rect.origin = CGPoint(x: -offset.x, y: -offset.y)
        
        if animated {
            animatedScroll(rect: rect)
        }else{
            
            directlyScroll(rect: rect)
        }
        
        
    }
    
    
    private func animatedScroll(rect:CGRect){
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            
            self.contentView.frame = rect
            
            self.delegate?.ge_scrollViewDidScrollingAnimation?(self)
            
            
        }) { (finished) in
            
            self.delegate?.ge_scrollViewDidEndDecelerating?(self)
            
            let pagex = rect.origin.x / self.frame.width
            let pagey = rect.origin.y / self.frame.height
            
            self.scrollToPage?(Page(x: pagex.absolute.int, y: pagey.absolute.int))
            
            
        }
    }
    
    private func directlyScroll(rect:CGRect){
        
        self.contentView.frame = rect
        
        let pagex = rect.origin.x / self.frame.width
        let pagey = rect.origin.y / self.frame.height
        
        self.scrollToPage?(Page(x: Int(pagex), y: Int(pagey)))
        
    }
    
    
    
    
    
}

// MARK:- Private Method
extension ScrollView{
    
    /// pan手势函数
    ///
    /// - Parameter pan: pan gesture
    @objc fileprivate func pan(_ pan:UIPanGestureRecognizer){
        
        
        switch pan.state {
        case .began: ///开始拖动
            
            
            delegate?.ge_scrollViewWillBeginDragging?(self)
            
            pan.setTranslation(CGPoint(x:0,y:0), in: contentView)
            startPoint = pan.translation(in: contentView)
            
        case  .changed: // 拖动中
            delegate?.ge_scrollViewDidScroll?(self)
            
            let point = pan.translation(in: contentView)
            
            let deltaX : CGFloat
            let deltaY : CGFloat
            
            switch(direction ){
                //            case .any:
                //                deltaX = point.x - startPoint!.x
                //                deltaY = point.y - startPoint!.y
                
            case .horizontal:
                deltaX = point.x - startPoint!.x
                deltaY = 0
                
            case .vertical:
                
                deltaX = 0
                deltaY = point.y - startPoint!.y
            }
            
            
            let newCenter = CGPoint(x: contentView.center.x + deltaX, y: contentView.center.y + deltaY)
            
            contentView.center = newCenter
            
            pan.setTranslation(CGPoint(x:0,y:0), in: contentView)
            
        case .ended:
            
            keepBounds(velocity: pan.velocity(in: contentView))
            
            delegate?.ge_scrollViewDidEndDragging?(self, willDecelerate: false)
            
        case .possible,.cancelled,.failed: break
            
        }
        
    }
    
    
    private func keepBounds(velocity:CGPoint){
        
        
        var pageX = 0
        var pageY = 0
        var pageCanEnable = false
        
        
        switch direction {
        // 水平
        case .horizontal: scrollHorizontal(velocity: velocity , canPageEnable: &pageCanEnable , scrollToPage: &pageX)
        // 垂直
        case .vertical: scrollVertical(velocity: velocity, canPageEnable: &pageCanEnable, scrollToPageY: &pageY)
        }
        
        
        if pageEnable && pageCanEnable {
            
            let targetPage = Page(x: pageX, y: pageY)
            
            scrollToPage?(targetPage)
            
        }
        
    }
    
    
    
    /// 水平滚动或者any滚动
    ///
    /// - Parameters:
    ///   - velocity: 滚动速率
    ///   - canPageEnable: 是否可以满足分页
    ///   - pageX: 水平滚动到的页数
    private func scrollHorizontal(velocity:CGPoint , canPageEnable: inout Bool , scrollToPage pageX: inout Int){
        
        var rect = contentView.frame
        
        if rect.origin.x > 0{ // 向右滑动,超过范围
            
            rect.origin.x = 0
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                
                self.contentView.frame = rect
            })
            
        }else if (rect.maxX < frame.width){ // 向左滑动查过范围
            
            rect.origin.x = -(contentSize.width - frame.width)
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                
                self.contentView.frame = rect
                
            })
            
            
        }else{
            
            let count = ( contentSize.width / frame.width).int
            let pageable = frame.width * count.cgfloat == contentSize.width
            
            if pageEnable && pageable{
                
                let width = frame.width
                
                let result = rect.origin.x / width
                let beforeDot = result.int
                
                var flag = 0
                if result != 0{
                    flag = ( result / result.absolute ).int
                }
                
                let reminder = result - beforeDot.cgfloat
                var additional = flag.cgfloat * ( reminder.absolute >= 0.5 ? width : 0 )
                
                
                // 拖动速到大于某个值时,默认切换一页
                if velocity.x < -sensibility.rawValue{ // 左滑动
                    
                    additional = CGFloat(flag) * width
                    
                }else if(velocity.x > sensibility.rawValue){ // 右滑动
                    
                    additional = 0
                    
                }
                
                let x = CGFloat(beforeDot) * width + additional
                
                if reminder != 0{
                    
                    rect.origin.x = x
                    
                    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                        
                        self.contentView.frame = rect
                    })
                }
                
                // 根据实际情况,判断是否真的可以分页,及当前滚到到哪一页.
                canPageEnable = true
                pageX = ( (rect.origin.x / frame.width).absolute ).int
                
                
            }
        }
        
        
    }
    
    
    /// 垂直或者any滚动
    ///
    /// - Parameters:
    ///   - velocity: 滚动速率
    ///   - canPageEnable: 是否真的可以满足分页
    ///   - pageY: 垂直滚动页数
    private func scrollVertical(velocity:CGPoint,canPageEnable: inout Bool,scrollToPageY pageY:inout Int){
        
        var rect = contentView.frame
        
        if rect.origin.y > 0 { // 往下拉过度
            
            rect.origin.y = 0
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView.frame = rect
            })
            
        }else if  rect.maxY < frame.height{
            
            rect.origin.y = -(contentSize.height - frame.height)
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                
                self.contentView.frame = rect
            })
        }else{
            
            let count = (contentSize.height / frame.height).int
            let pageable = frame.height * count.cgfloat == contentSize.height
            
            if pageEnable && pageable{
                
                let height = frame.height
                
                let result = rect.origin.y / height
                let beforeDot = result.int
                
                var flag = 0
                if result != 0{
                    flag = ( result / result.absolute ).int
                }
                
                let reminder = result - beforeDot.cgfloat
                var additional = flag.cgfloat * ( reminder.absolute >= 0.5 ? height : 0 )
                
                
                // 拖动速到大于某个值时,默认切换一页
                if velocity.y < -sensibility.rawValue{ // 上滑动
                    
                    additional = flag.cgfloat * height
                    
                }else if(velocity.y > sensibility.rawValue){ // 下滑动
                    
                    additional = 0
                    
                }
                
                let y = CGFloat(beforeDot) * height + additional
                
                if reminder != 0{
                    
                    rect.origin.y = y
                    
                    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                        
                        self.contentView.frame = rect
                    })
                }
                
                // 根据实际情况,判断是否真的可以分页,及当前滚到到哪一页.
                canPageEnable = true
                pageY = (rect.origin.y / frame.height).absolute.int
                
                
            }
            
        }
        
        
    }
    
}

