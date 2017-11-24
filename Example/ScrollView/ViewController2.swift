//
//  ViewController2.swift
//  GEScrollView
//
//  Created by 黄继平 on 2017/11/24.
//  Copyright © 2017年 Eric. All rights reserved.
//

import UIKit
import PullToRefreshKit




class ViewController2: UITableViewController {

    private var header : DefaultRefreshHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = randomColor()

        config()
    }

 
}


extension ViewController2 {
    
    func config() {
     
        
        header = tableView.setUpHeaderRefresh {[weak self] in
            self?.tableView.switchRefreshHeader(to: .normal(.success, 1))
        }

    }
    
    

    
}

extension ViewController2 {
    
    /// 生成随机色
    ///
    /// - Returns: 随机色
    func randomColor() -> UIColor{
        
        let r =  CGFloat(arc4random_uniform(256)) / 255.0
        let g =  CGFloat(arc4random_uniform(256)) / 255.0
        let b =  CGFloat(arc4random_uniform(256)) / 255.0
        
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0);
    }
}
