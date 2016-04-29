//
//  LLuMessageTableViewController.swift
//  LLuSwiftWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuMessageTableViewController: LLuBaseTableViewController {

    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        //1.如果没有登录，就设置未登录界面的信息
        if !userLogin {
            
            visitorView?.setupVisitInfo(false, imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微薄，发给你的消息，都会在这里收到通知")
        }
        
        
    }
}
