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
        //主题颜色（字体）
        bar.tintColor = UIColor.black
        bar.barTintColor = UIColor.white
        bar.barStyle = .default
        

    }

    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
//        let count = self.viewControllers.count
//        if(count > 1){
//            let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//            spaceItem.width = -10
//            
//            let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//            leftBtn.addTarget(viewController, action: #selector(leftAction), for: .touchUpInside)
//            
//            let bgImage = UIImage(named: "leftBack@2x.png")
//            leftBtn.setImage(bgImage, for: .normal)
//            let leftItem = UIBarButtonItem(customView: leftBtn)
//            viewController.navigationItem.leftBarButtonItems = [spaceItem,leftItem]
//        }
        
    }
    
    func leftAction() -> Void {
//        self.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
