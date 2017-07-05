//
//  NetWorkTools.swift
//  网易首页swift
//
//  Created by hupeng on 17/3/20.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import Alamofire

enum  MethodType{
    case get
    case post
}

class NetWorkTools {
 
    class func requestData(URLString:String,type:MethodType,parmertas:[String:Any]? = nil,finsishCallBack: @escaping (_ result:Any)->()){
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parmertas).responseJSON { (respose) in
            guard let result = respose.result.value  else{
                print(respose.result.error ?? "")
                return
            }
            finsishCallBack(result)
        }
        
    }
}
