//
//  RootViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController,TitleViewDelegate {

    var titleView:TitleView?
    var bgScroView:UIScrollView?
    var isOpen:Bool = false
   lazy var dataSource:[CatModel] = [CatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        self.setupLeftBtn(imageName: "mainSlide")
        self.setupRight(imageName: "searchIcon@2x.png")
        
        titleView = TitleView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        titleView!.delegate = self
        self.view.addSubview(titleView!)
        
        
        bgScroView = UIScrollView(frame: CGRect(x: 0, y: 44, width: kScreenW, height: kScreenH - 44 - 64))
        bgScroView?.showsHorizontalScrollIndicator = false
        bgScroView?.showsVerticalScrollIndicator = false
        bgScroView?.delegate = self
        bgScroView?.isPagingEnabled = true
        bgScroView?.backgroundColor = UIColor.white
        self.view.addSubview(bgScroView!)

        self.view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(selectorFunction(note:)), name: NSNotification.Name("goLogin"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(goNext(note:)), name: NSNotification.Name(kSelectFun), object: nil)
        getCatList()
    }
    
    
    override func rightAction() {
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func goNext(note:Notification) -> Void {
        let index = note.object as?IndexPath
        
        if(index?.row == 0){
            
            let url = URL(string: "https://itunes.apple.com/app/id1259753353")
            UIApplication.shared.openURL(url!)
        }
        
        if(index?.row == 1){
            let aboutVC = AboutViewController()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }
        if(index?.row == 2){
            let collectVC = CollectionViewController(nibName: "CollectionViewController", bundle: nil)
             self.navigationController?.pushViewController(collectVC, animated: true)
        }
        if(index?.row == 3){
            let setVC = SetViewController(nibName: "SetViewController", bundle: nil)
            self.navigationController?.pushViewController(setVC, animated: true)
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

// MARK:-titleView delegate
    func titleViewBtnClick(index: Int) {
        var point = self.bgScroView?.contentOffset
        point?.x = CGFloat(index)   * kScreenW
        self.bgScroView?.setContentOffset(point!, animated: true)
    }
}



extension RootViewController{
    func getCatList() -> Void {
        let url = SERVER_IP + "/index.php/api/AppInterface/getCatLst"
       
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: nil) { (response) in
            
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[[String:Any]] else{return}
            for dic in data{
                let catModel = CatModel()
                catModel.catId = dic["id"] as?String
                catModel.catName = dic["catename"] as?String
                self.dataSource.append(catModel)
                
                let homeVC = HomeViewController()
                homeVC.carId = catModel.catId!
                self.addChildViewController(homeVC)
            }
             self.titleView?.titleS = self.dataSource
            self.bgScroView!.contentSize = CGSize(width: Int(self.bgScroView!.frame.width) * self.dataSource.count , height: Int(self.bgScroView!.frame.height))
            self.scrollViewDidEndScrollingAnimation(self.bgScroView!)
           
            

        }
    }
}

extension RootViewController:UIScrollViewDelegate{
    //只要滑动就走
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let index = Int(offset / kScreenW)
        self.titleView?.moveLine(index: index)
        
        let catModel = self.dataSource[index]
        let homeVC = self.childViewControllers[index] as?HomeViewController
        homeVC?.carId = catModel.catId!
        homeVC?.view.frame = CGRect(x: offset, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(homeVC!.view)
        
        
    }
    
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
//    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isOpen = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.x < -50){
             print(scrollView.contentOffset.x)
            
            if(isOpen == false){
                kDelegate?.drawerController?.toggleDrawerSide(.left, animated: true, completion: { (yes) in
                    self.isOpen = true
                })
 
            }
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
       
    }
}
