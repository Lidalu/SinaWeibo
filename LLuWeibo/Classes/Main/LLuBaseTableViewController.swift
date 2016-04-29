//
//  LLuBaseTableViewController.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuBaseTableViewController: UITableViewController, VisitorViewDelegate {

    //定义一个变量保存用户当前是否登录
    var userLogin = true
    //定义属性保存未登录界面
    var visitorView: LLuVisitorView?
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK - 内部控制方法
    /**
     创建未登录界面
     */
    private func setupVisitorView() {
        
        //1.初始化未登录界面
        let customView = LLuVisitorView()
        customView.delegate = self
        customView.backgroundColor = UIColor.whiteColor()
        view = customView
        visitorView = customView
        
        //2.设置导航条未登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registerBtnWillClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginBtnWillClick))

    }
    
    // MARK -VisitorViewDelegate
    func loginBtnWillClick() {
        
        print(#function)
    }
    
    func registerBtnWillClick() {
        
        print(#function)
    }
}
