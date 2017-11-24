//
//  ViewController.swift
//  GEScrollView
//
//  Created by 黄继平 on 2017/11/24.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import ScrollView

class ViewController: UIViewController {

    
    var scrollView:ScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configSubviews()
    }

    

}

extension ViewController {
    
    private func configSubviews(){
        
        let scrollFrame = CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        let subviewsCount = 3

        scrollView = ScrollView(frame:scrollFrame , contentSize: CGSize(width: scrollFrame.width * subviewsCount.cgfloat, height: scrollFrame.height))
        
        view.addSubview(scrollView)
        
        scrollView.scrollToPage = { page in
            print("default horizontal scroll to page:\(page.x)")
        }
        
        
        for i in 0..<subviewsCount {
            
            let subVC = ViewController2()
            
            addChildViewController(subVC)
            scrollView.addChildView(subVC.view, index: i)
        }
    }
    
}

