//
//  LLuHttpClient.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit
import AFNetworking

public enum HttpRequestType {
    case HttpGet
    case HttpPost
    case HttpDelete
    case HttpPut
}


class LLuHttpClient: NSObject {

    var AFNManager: AFHTTPSessionManager?
    var isConnect:Bool = false

    
    static let tools:LLuHttpClient = {
    
        var t = LLuHttpClient()
        t.AFNManager?.requestSerializer = AFHTTPRequestSerializer()
        t.AFNManager!.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/html", "text/json", "text/javascript", "text/plain", "image/gif") as? Set<String>
        

        LLuHttpClient().openNetMonitoring()

        return t
        
    }()

    
    //获取单例的方法
    class func sharedNetworkTools() -> LLuHttpClient {
        
        return tools
    }
}

extension LLuHttpClient {
    
     func openNetMonitoring() -> Void {
        
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock { (status) in
            switch (status) {
               
            case .Unknown:
                self.isConnect = false
            case .NotReachable:
                self.isConnect = false
            case .ReachableViaWiFi:
                self.isConnect = true
            case .ReachableViaWWAN:
                self.isConnect = true
            default :
                break
            }
        }
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        isConnect = true
    }
    
    
    // (response: AnyObject?, error: NSError?)->()
    // 定义请求完成的回调的别名
    typealias LLuRequestCallBack = (response: AnyObject?, error: NSError?)->()
    
   internal func request(url: String, method: HttpRequestType, parameters: AnyObject, finished:LLuRequestCallBack) -> Void {
    
    
    //请求前预处理闭包
//    let PrepareExecuteBlock = {}
    
    // 定义请求成功的闭包
    let SuccessBlock = { (dataTask: NSURLSessionDataTask, responseObject: AnyObject?) -> Void in
    }
    
    // 定义请求失败的闭包
    let FailureBlock = { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
    }
    
        /**
         请求的URL
         */
        print("请求网络地址为：\(url)")
    

        /**
         *判断网络状况（有链接：执行请求；无链接：弹出提示）
         */
        if isConnectionAvailable() {
            
            //预处理
//            if PrepareExecuteBlock {
//                prepareExecute()
//            }
        
            switch method {
            case .HttpGet:
                print("faf")
               AFNManager!.GET(url, parameters: parameters, progress: nil, success: SuccessBlock, failure: FailureBlock)
            case .HttpPost:
                print("post")
                AFNManager!.POST(url, parameters: parameters, progress: nil, success: SuccessBlock, failure: FailureBlock)
            case HttpRequestType.HttpDelete:
                print("Delete")
               AFNManager!.DELETE(url, parameters: parameters, success: SuccessBlock, failure: FailureBlock)
            case HttpRequestType.HttpPut:
                print("PUT")
                AFNManager!.PUT(url, parameters: parameters, success: SuccessBlock, failure: FailureBlock)
                
            default:
                break
            }
        } else {
            
            /**
             *  网络错误
             */
            showExceptionDialog()
            /**
             *  发出网络异常通知广播
             */
        NSNotificationCenter.defaultCenter().postNotificationName("k_NOTI_NETWORK_ERROR", object: nil)
            
        }
        
    }
    
    private func isConnectionAvailable() -> Bool {
        
        return isConnect
    }
    
    private func showExceptionDialog() -> Void {
        
        UIAlertController(title: "提示", message: "网络异常", preferredStyle: UIAlertControllerStyle.Alert)
    }
}
