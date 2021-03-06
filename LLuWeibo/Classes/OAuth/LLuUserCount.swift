//
//  LLuUserCount.swift
//  LLuWeibo
//
//  Created by ma c on 16/5/2.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuUserCount: NSObject, NSCoding {

    var access_token: String?
    
    var expires_in: NSNumber?
    
    var uid: String?
    
    override init() {
        
        
    }
    
     init(dict: [String: AnyObject]) {
        
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
    }
    
    override var description: String {
        
        let properties = ["access_token", "expires_in", "uid"]
        let dict = self.dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    
    class func userLogin() -> Bool {
        
        return LLuUserCount.loadAccount() != nil
    }
    
    // MARK - 保存和读取
    func saveAccount() -> Void {
        
        NSKeyedArchiver.archiveRootObject(self, toFile: "account.plist".cacheDir())
    }
    
    //记载授权模型
    static var account: LLuUserCount?
   class func loadAccount() -> LLuUserCount? {
    
    //1.判断是否已经加载过
    if account != nil {
        
        return account
    }
    //2.加载授权模型
    account = NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as?LLuUserCount
    
        return account
    }
    
    // MARK - NSCoding
    //将对象写入到文件中
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
    }

    
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = (aDecoder.decodeObjectForKey("uid") as! String)
    }
    
}
