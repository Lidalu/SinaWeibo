//
//  LLuNetWorkTools.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit
import AFNetworking

class LLuNetWorkTools: AFHTTPSessionManager {


   static let tools:LLuNetWorkTools = {

        //注意：baseURL一定要以/结尾
        let url = NSURL(string: "https://api.weibo.com/")
    
        let t = LLuNetWorkTools(baseURL: url)
    
        //设置AFN能够接受的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        return t
    }()
    
    //获取单例的方法
    class func sharedNetworkTools() -> LLuNetWorkTools {
        
        return tools
    }
    
}
