//
//  MainNaviController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class MainNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bar = UINavigationBar.appearance()
        bar.isTranslucent = false
        bar.tintColor = UIColor.white
        bar.barStyle = .default
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
