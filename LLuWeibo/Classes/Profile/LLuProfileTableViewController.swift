//
//  LLuProfileTableViewController.swift
//  LLuSwiftWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuProfileTableViewController: LLuBaseTableViewController {

    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        //1.如果没有登录，就设置未登录界面的信息
        if !userLogin {
            
            visitorView?.setupVisitInfo(false, imageName: "visitordiscover_image_profile", message: "登录后，你的微薄、相册、个人资料会显示在这里，展示给别人")
        }
        
        
    }
}
