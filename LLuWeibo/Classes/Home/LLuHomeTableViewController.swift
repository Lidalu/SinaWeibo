//
//  LLuHomeTableViewController.swift
//  LLuSwiftWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    
//    func getBannerList() -> Void {
//        
//        let parameters: NSDictionary = ["params": "{\"type\":\"123546789abc\",\"province\":\"110000\"}",
//            "os":"2",
//            "sign":"F4DDF6F67E383199",
//            "version":"2.4"];
//        
//         let urlString: NSString = "http://app.gegejia.com/yangege/appNative/resource/homeList";
//        LLuHttpClient.sharedNetworkTools().request(urlString, method: HttpRequestType.Post, parameters: parameters, prepareExecute: nil, success: nil, failure: nil)
//    }
    
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
