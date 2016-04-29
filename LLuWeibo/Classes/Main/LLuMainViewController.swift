//
//  LLuMainViewController.swift
//  LLuSwiftWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuMainViewController: UITabBarController {

    
    override func viewDidLoad() {
        
        //设置当前控制器对应tabbar的颜色
        //注意：在iOS7以前如果设置了tintColor只有文字会变，而图片不会变
//        tabBar.tintColor = UIColor.orangeColor()
       
        
        //添加子控制器
        addChildViewControllers()
        
        //从iOS7之后就不推荐在viewDidLoad中设置frame
//        print(tabBar.subviews)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        print("=============")
//        print(tabBar.subviews)
        
        //添加加号按钮
        setUpComposeBtn()

    }
    
    private func setUpComposeBtn() {
        
        //1.添加加号按钮
        tabBar.addSubview(composeBtn)
        //2.调整加号按钮的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat (viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
//        composeBtn.frame = rect
        /**
         更改ComposeBtn的位置
         
         - parameter <Trect: 是frame的大小
         - parameter <Tdx:   是x方向偏移的大小
         - parameter <Tdy:   是y方向偏移的大小
         */
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }
    
    /**
     添加所有子控制器
     */
    private func addChildViewControllers() {
        
        //1.获取JSON文件的路径
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings", ofType: "json")
        //2.通过文件路径创建NSData
        if let jsonPath = path {
            
            let jsonData = NSData(contentsOfFile: jsonPath)
            
            do {
                
                //有可能发生异常的代码放到这里
                //3.序列化JSON数据 ---> Array
                //try: 发生异常时会跳到catch继续执行
                //try！：发生异常程序直接崩溃
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                //4.遍历数组，动态创建控制器和设置数据
                
                //zaiswift中，如果需要便利一个数组，必须明确数据的类型
                for dict in dictArr as! [[String: String]] {
                    
                    //报错的原因是因为addChildViewController参数必须有值，但是字典的返回值是可选类型
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
                
            } catch {
                
                //发生异常之后会执行的代码
                print(error)
                //从本地创建控制器
                addChildViewController("LLuHomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("LLuMessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("LLuDiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("LLuProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
        }
    }
    
    /**
     初始化子控制器
     
     - parameter childController: 需要初始化的子控制器
     - parameter title:           子控制器的标题
     - parameter imageName:       子控制器的图片
     */
    private func addChildViewController(childControllerName: String, title: String, imageName: String) {
        
        //-1.动态获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        //0.将字符串转换为类
        //默认情况下命名空间就是项目的名称，但是命名空间是可以修改的  ProductName
        let cls:AnyClass? = NSClassFromString("\(ns)." + childControllerName)
//        print(cls)
        
        //0.2通过类创建对象
        //0.2.1将AnyClss转换为指定的类型
        let vcCls = cls as! UIViewController.Type
        //0.2.2通过Class创建对象
        let vc = vcCls.init()
        
        //1.1设置首页tabbar对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        //1.2设置导航条对应的数据
        vc.title = title
        
        //2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        
        //3.将导航控制器添加到当前控制器上
        addChildViewController(nav)
    }
    
    // MARK - 懒加载
    private lazy var composeBtn: UIButton = {
        
        let btn = UIButton(type: UIButtonType.Custom)
        //设置前景图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        //设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(LLuMainViewController.composBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    /**
     监听加号按钮点击
     注意：监听按钮点击的方法不能是私有方法
     */
    //按钮的点击事件的调用是由运行循环监听并且以消息机制传递的。因此，按钮监听函数不能设置为private
    func composBtnClick() {
        
        print(#function)
    }
}
