//
//  LLuUserCount.swift
//  LLuWeibo
//
//  Created by ma c on 16/5/2.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit

class LLuUserCount: NSObject {

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
    
}
