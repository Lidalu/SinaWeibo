//
//  LLuVisitorView.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/22.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

//Swift中如何定义协议,必须遵守NSObjectProtocol
protocol VisitorViewDelegate: NSObjectProtocol {
    
    //登录回调
    func loginBtnWillClick()
    //注册回调
    func registerBtnWillClick()
}



class LLuVisitorView: UIView {

    //定义一个属性保存代理对象, 
    //一定要加weak，以防循环引用
   weak var delegate: VisitorViewDelegate?
    
    
    /**
     设置未登录界面
     
     - parameter isHome:    是否为首页
     - parameter imageName: 需要展示的图标文件
     - parameter message:   需要展示的文本内容
     */
    func setupVisitInfo(isHome: Bool, imageName: String, message: String) -> Void {
        
        //如果不是首页，就隐藏转盘
        iconView.hidden = !isHome
        //修改中间图标
        homeIcon.image = UIImage(named: imageName)
        //修改文本
        messageLabel.text = message
        
        //判读是否需要执行动画
        if isHome {
            
            startAnimation()
        }
    }
    
    func loginBtnClick() -> Void {
        
       delegate?.loginBtnWillClick()
    }
    
    func registerBtnClick() -> Void {
        
        delegate?.registerBtnWillClick()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //1.添加子控件
        
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerBtn)
        //2.布局子控件
        //2.1设置背景
        iconView.llu_AlignInner(type: LLu_AlignType.Center, referView: self, size: nil)
        //2.2设置小房子
        homeIcon.llu_AlignInner(type: LLu_AlignType.Center, referView: self, size: nil)
        //2.3设置文本
        messageLabel.llu_AlignVertical(type: LLu_AlignType.BottomCenter, referView: iconView, size: nil)
        // “哪个控件” 的 “什么属性” 等于 “另外一个控件” 的 “什么属性” 乘以 “多少” 加上 “多少”
        let widthCons = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        
        //2.4设置按钮
        registerBtn.llu_AlignVertical(type: LLu_AlignType.BottomLeft, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        loginButton.llu_AlignVertical(type: LLu_AlignType.BottomRight, referView: messageLabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        //2.5设置蒙板
        maskBGView.llu_Fill(self)
    }
    
    //Swift推荐我们自定义一个控件，要么使用纯代码，要么就用xib/Sb
    required init?(coder aDecoder: NSCoder) {
        
        //如果通过xib/sb创建该类，那么就会崩溃
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - 内部控制方法
    private func startAnimation() {
        
        //1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        //2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        //默认该属性为yes，代表动画执行完成就移除
        anim.removedOnCompletion = false
        //3.将动画添加到图层上
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // MARK - 懒加载控件
    //转盘
    private lazy var iconView: UIImageView = {
       
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
        
    }()
    //图标
    private lazy var homeIcon: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    //文本
    private lazy var messageLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "发表看法顾客发噶咖啡馆你氛围和覅恢复和缺口大小白屋"
        return label
    }()
    //登录按钮
    private lazy var loginButton: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
    
    //注册按钮
    private lazy var registerBtn: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)

        return btn
    }()
    
    private lazy var maskBGView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()
}
