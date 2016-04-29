//
//  LLuHomeTableViewController.swift
//  LLuSwiftWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit
import SVProgressHUD

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

class LLuHomeTableViewController: LLuBaseTableViewController {

    //Command + Option + Shift + 方向键打开合上代码
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        //1.如果没有登录，就设置未登录界面的信息
        if !userLogin {
            
            visitorView?.setupVisitInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
        }
        
        //2.初始化导航条
        setupNav()
        
        //3.注册通知，监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(change), name: LLuPopoverAnimationWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(change), name: LLuPopoverAnimationWillDismiss, object: nil)

    }
    
    deinit {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     修改标题按钮的状态
     */
    func change() -> Void {
        
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
        
    }
    
    /**
     初始化导航条
     */
    private func setupNav() {
        
        //1.左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftItemClick))
        //2.右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightItemClick))
        
        //2.初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("李大大大大帅 ", forState: UIControlState.Normal)
        
        // MARK - Button的添加事件方法1  错误
//        titleBtn.addTarget(self, action: Selector("titleBtnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        // MARK - Button的添加事件方法2苹果推荐
//        titleBtn.addTarget(self, action: #selector(LLuHomeTableViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        // MARK - Button的添加事件方法3苹果推荐后简写
        titleBtn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(btn: TitleButton) -> Void {
        
        //1.修改箭头方向
//        btn.selected = !btn.selected
        
        //2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场的代理
//        vc?.transitioningDelegate = self
        vc?.transitioningDelegate = popoverAnimation
        //2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftItemClick() -> Void {
        
        print(#function)
    }
    
    //打开二维码
    func rightItemClick() -> Void {
        
        print(#function)
        let QRCodeSb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let QRCodeVC = QRCodeSb.instantiateInitialViewController()
        presentViewController(QRCodeVC!, animated: true, completion: nil)
        
    }
    
    // MARK - 懒加载
    //一定要定义一个属性来保存自定义转场对象，否则会报错
    private lazy var popoverAnimation: PopoverAnimation = {
        
        let pa = PopoverAnimation()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
}
