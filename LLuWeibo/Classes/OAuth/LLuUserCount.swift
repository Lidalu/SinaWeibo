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
    
    
    // MARK - 保存和读取
    func saveAccount() -> Void {
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        print("filePath \(filePath)")
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    
    //记载授权模型
   class func loadAccount() -> LLuUserCount? {
        
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
    let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
    print("filePath \(filePath)")
    
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as?LLuUserCount
        
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
