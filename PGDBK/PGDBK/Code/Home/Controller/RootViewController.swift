//
//  RootViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLeftBtn(imageName: "mainSlide")

        self.view.backgroundColor = UIColor.red
        NotificationCenter.default.addObserver(self, selector: #selector(selectorFunction(note:)), name: NSNotification.Name("goLogin"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(goNext(note:)), name: NSNotification.Name(kSelectFun), object: nil)
    }
    
    
    func goNext(note:Notification) -> Void {
        let index = note.object as?IndexPath
        if(index?.row == 1){
            let homeVC = HomeViewController()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    func selectorFunction(note:Notification) -> Void {
        
        let come = note.object as?String
        if(come == "1"){
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.navigationController?.pushViewController(loginVC, animated: true)
        }else{
            
            let homeVC = HomePageViewController(nibName: "HomePageViewController", bundle: nil)
            self.navigationController?.pushViewController(homeVC, animated: true)
            
        }
        
       

    }
    
    override func leftAction() {
        kDelegate?.drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
