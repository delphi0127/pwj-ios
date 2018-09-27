//
//  SwiftObject.swift
//  抛丸机销售助手v0.1
//
//  Created by aries365.com on 15/11/4.
//  Copyright (c) 2015年 Apollo. All rights reserved.
//

import UIKit

import Foundation

@objc class SwiftObject: NSObject {
    
    
    
    var city: NSString = "abc"
    
    func sayHello(greeting: String, withName name: String) -> String{
    
        let string = "Hi"
        
        city = "123"
        
        return string
    
    }
}
