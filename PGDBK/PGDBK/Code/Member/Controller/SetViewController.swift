//
//  SetViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/7.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import Kingfisher

import SVProgressHUD
class SetViewController: BaseViewController {

    @IBOutlet var setTable: UITableView!
    var logoutBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "设置"
        
        self.view.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f7)
        self.setTable.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f7)
        self.setTable.tableFooterView = UIView()
        self.setTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupFooter()

        // Do any additional setup after loading the view.
    }
    
    
    func setupFooter() -> Void {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 80))
        footerView.backgroundColor = UIColor.clear
        
        
        let btn = UIButton(frame: CGRect(x: 0, y: 20, width: kScreenW, height: 40))
        btn.backgroundColor = UIColor.white
        btn.setTitle("退出登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        footerView.addSubview(btn)
        
        self.logoutBtn = btn
        
        self.setTable.tableFooterView = footerView
        
        let uid = UserDefaults.standard.object(forKey: "userId") as?String
        if(uid == nil){
            self.logoutBtn?.isHidden = true
        }
        
    }
    
    func logout() -> Void {
        
        let actionsheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确定")

        actionsheet.show(in: self.view)
        
    }
    
    func delay() -> Void {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.synchronize()
        SVProgressHUD.dismiss()
        SVProgressHUD.showSuccess(withStatus: "退出成功")
        self.logoutBtn?.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("logoutSuccess"), object: nil)
    }
    
    func delayClear() -> Void {
        let cache = KingfisherManager.shared.cache
        cache.clearDiskCache()//清除硬盘缓存
        cache.clearMemoryCache()//清理网络缓存
        cache.cleanExpiredDiskCache()//清理过期的，或者超过硬盘限制大小的
        SVProgressHUD.showSuccess(withStatus: "清理成功")
    }





}



extension SetViewController:UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 0){
            let kefuVC = KefuViewController(nibName: "KefuViewController", bundle: nil)
            self.navigationController?.pushViewController(kefuVC, animated: true)
        }
        
        if(indexPath.row == 1){
            SVProgressHUD.show(withStatus: "正在清理")
            SVProgressHUD.setDefaultStyle(.dark)
            self.perform(#selector(delayClear), with: nil, afterDelay: 1.5)
        }
        if(indexPath.row == 2){
            
             let alert = UIAlertView(title: "提示", message: "确定拨打电话吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alert.show()

            
           
        }
        
       
        
     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = kRGBColorFromHex(rgbValue: 0x666666)
        cell.accessoryType = .disclosureIndicator
        if(indexPath.row == 0){
            cell.textLabel?.text = "意见反馈"
        }
        if(indexPath.row == 1){
            cell.textLabel?.text = "清理缓存"
        }
        if(indexPath.row == 2){
            cell.textLabel?.text = "联系我"
        }
        return cell
    }
    
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if(buttonIndex == 0){
            SVProgressHUD.show(withStatus: "正在退出")
            SVProgressHUD.setDefaultStyle(.dark)
            self.perform(#selector(delay), with: nil, afterDelay: 1.5)

        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if(alertView.cancelButtonIndex != buttonIndex){
            let app = UIApplication.shared
            let url = URL(string: "tel://13163763245")
            app.openURL(url!)
        }
    }
}
