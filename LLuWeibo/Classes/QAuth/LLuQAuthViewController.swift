//
//  LLuQAuthViewController.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuQAuthViewController: UIViewController {

    let WB_App_Key = "3877804788"
    let WB_App_Secret = "1fbe7f7779e1182d864a8fcaa22e81e5"
    let WB_App_redirect_uri = "http://www.lidalu1125.cn"
    
    override func loadView() {
        
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //0.初始化导航条
        navigationItem.title = "李大大大帅的微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        //1.获取未授权的RequestToken
        //要求SSL1.2
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_App_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func close() -> Void {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //懒加载
    private lazy var webView: UIWebView = {
        
        let wv = UIWebView()
        return wv
        
    }()
}
