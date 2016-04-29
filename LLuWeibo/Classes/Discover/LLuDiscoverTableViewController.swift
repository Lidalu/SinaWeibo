//
//  LLuDiscoverTableViewController.swift
//  LLuSwiftWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuDiscoverTableViewController: LLuBaseTableViewController {

    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        //1.如果没有登录，就设置未登录界面的信息
        if !userLogin {
            
            visitorView?.setupVisitInfo(false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微薄尽在掌握，不再会与实事潮流擦肩而过")
        }
        
        
    }
}
