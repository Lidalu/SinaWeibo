//
//  LLuQAuthViewController.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

/*
 Sina 授权
 1.成为新浪开发者
 登录open.weibo.com网站，注册一个账号
 2.创建一个应用程序
 填写应用程序信息
 名称：李大大大大帅 来自：XXX
 App Key：3877804788
 App Secret：1fbe7f7779e1182d864a8fcaa22e81e5
 3.获取QAuth授权
 3.1获取未授权的RequestToken
 3.2获取已经授权的RequestToken
 3.3利用已经授权的RequestToken换取AccessToken
 只要用户登录成功，服务器就会返回RequestToken（字符串）
 https://api.weibo.com/oauth2/authorize?client_id=3877804788&redirect_uri=http://www.lidalu1125.cn
 注意：1.不能有多余的空格       (error:invalid_request)
 2.如果appkey不对也会报错 (error:invalid_client)
 3.如果uri不对也会报错     (error:redirect_uri_mismatch)
 如果是第一次对某个APP授权，会跳转到授权界面
 授权成功：http://www.lidalu1125.cn/?code=253d8bc1c60c810b446ff93d7d27434a
 授权取消：http://www.lidalu1125.cn/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
 授权成功后code = 字符串就是RequestToken
 获取授权OAuth2的access_token接口
 URL：
 https://api.weibo.com/oauth2/access_token
 HTTP请求方式： POST
 
 请求参数             必选    类型及范围           说明
 client_id          true	string      申请应用时分配的AppKey。
 client_secret      true	string      申请应用时分配的AppSecret。
 grant_type         true	string	请求的类型，填写authorization_code
 */

class LLuOAuthViewController: UIViewController {

    let WB_App_Key = "3877804788"
    let WB_App_Secret = "1fbe7f7779e1182d864a8fcaa22e81e5"
    let WB_redirect_uri = "http://www.lidalu1125.cn"
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0.初始化导航条
        navigationItem.title = "元祖兄的微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        
        // 1.获取未授权的RequestToken
        // 要求SSL1.2
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}

extension LLuOAuthViewController: UIWebViewDelegate
{
    // 返回ture正常加载 , 返回false不加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        print(request.URL?.absoluteString)
        
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri)
        {
            // 继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr)
        {
            // 授权成功
            // 1.取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        }else
        {
            // 取消授权
            // 关闭界面
            close()
        }
        
        return false
    }
    
    /**
     换取AccessToken
     
     :param: code 已经授权的RequestToken
     */
    private func loadAccessToken(code: String)
    {
        // 1.定义路径
        let path = "oauth2/access_token"
        // 2.封装参数
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri]
        
        // 3.发送POST请求
        LLuNetWorkTools.sharedNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) in
//       access_token      2.00dLOZWCWKs7OE9a35af53801WYMxD
//            print(JSON)
            
            //1.字典转模型
            /*
             plist: 特点是只能存储系统自带的数据类型
             将对象转换为JSON之后写入文件中 --->  在公司中已经开始使用
             偏好设置： 本质plist
             归档： 可以存储自定义对象
             数据库： 用于存储大数据，特点效率较高
            */
            let account = LLuUserCount(dict: JSON as! [String: AnyObject])
            //2.归档模型
            account.saveAccount()
            print(account)
            }) { (_, error) in
                
                print("错误\(error)")
        }
    }
}