//
//  Common.swift
//  HPZBTV
//
//  Created by hupeng on 17/3/22.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit




let kStatusBarH :CGFloat = 20

let kTabBarH :CGFloat = 49


let kNavigaitonBarH :CGFloat = 64

let kScreenW :CGFloat = UIScreen.main.bounds.width

let kScreenH :CGFloat = UIScreen.main.bounds.height

let kDelegate = UIApplication.shared.delegate as? AppDelegate


func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
    
             return UIColor(
                red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                
                     alpha: 1.0)
     }




