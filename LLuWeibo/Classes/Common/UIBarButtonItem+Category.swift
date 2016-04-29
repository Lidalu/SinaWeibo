//
//  UIBarButtonItem+Category.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/23.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class  func createBarButtonItem(imageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem{
     
            let btn = UIButton()
            btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
            btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
            btn.sizeToFit()
            btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
            return UIBarButtonItem(customView: btn)
    }
}