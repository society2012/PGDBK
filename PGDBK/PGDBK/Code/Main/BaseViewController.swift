//
//  BaseViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let count = self.navigationController?.viewControllers.count
        if(count! > 1){
            kDelegate?.drawerController?.openDrawerGestureModeMask = .custom
            kDelegate?.drawerController?.closeDrawerGestureModeMask = .custom
        }else{
            kDelegate?.drawerController?.openDrawerGestureModeMask = .all
            kDelegate?.drawerController?.closeDrawerGestureModeMask = .all
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //不写不能滑动返回
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as?UIGestureRecognizerDelegate
                if((self.navigationController?.viewControllers.count)! > 1){
            self.setupLeftBtn(imageName: "leftBack")
        }
    }
    
    // MARK:-init  按钮
    func setupLeftBtn(imageName:String) -> Void {
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        spaceItem.width = -10
        
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBtn.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        let bgImage = UIImage(named: imageName)
        leftBtn.setImage(bgImage, for: .normal)
        
        let leftItem = UIBarButtonItem(customView: leftBtn)
        
        self.navigationItem.leftBarButtonItems = [spaceItem,leftItem]
    }
    
    func setupRight(imageName:String) -> Void {
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        spaceItem.width = -10
        
        let rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBtn.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        let bgImage = UIImage(named: imageName)
        rightBtn.setImage(bgImage, for: .normal)
        
        let rightItem = UIBarButtonItem(customView: rightBtn)
        
        self.navigationItem.rightBarButtonItems = [spaceItem,rightItem]
        
    }
    
    // MARK:-点击事件
    
    func leftAction() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightAction() -> Void {
        print("点击")
    }


}
