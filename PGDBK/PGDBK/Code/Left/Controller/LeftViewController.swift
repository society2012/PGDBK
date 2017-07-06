//
//  LeftViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import Kingfisher

let kLeftCell:String = "kLeftCell"

let kSelectFun:String = "kSelectFun"

class LeftViewController: BaseViewController {

    @IBOutlet var leftTable: UITableView!
    
    var headView:LeftHeadView?
    
    
    var dataSource:[[String:String]] = {
        let array = [["startMe.png":"好评"],["aboutMe.png":"关于作者"],["collect.png":"收藏"],["setting.png":"设置"]]
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(note:)), name: NSNotification.Name("loginSuccess"), object: nil)
        setupHeadView()
        let id = UserDefaults.standard.object(forKey: "userId") as?String
         self.setupUserInfo(id: id)
    }
    
    func loginSuccess(note:Notification) -> Void {
        let id = note.object as?String
        self.setupUserInfo(id: id)
    }
    
    func setupHeadView() -> Void {
        
        self.leftTable.rowHeight = 45
        let nib = UINib(nibName: "LeftTableViewCell", bundle: nil)
        self.leftTable.register(nib, forCellReuseIdentifier: kLeftCell)
        let  headView = Bundle.main.loadNibNamed("LeftHeadView", owner: self, options: nil)?.first as?LeftHeadView
        headView?.frame = CGRect(x: 0, y: 0, width: self.leftTable.frame.width, height: 120 + 64)
        self.headView = headView
        self.leftTable.tableHeaderView = headView
        self.leftTable.tableFooterView = UIView()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapLogo))
        
        self.headView?.isUserInteractionEnabled = true
        self.headView?.addGestureRecognizer(tap)
    }
    
    func tapLogo() -> Void {
        closeLeftView()
        let id = UserDefaults.standard.object(forKey: "userId") as?String
        if(id == nil){
              NotificationCenter.default.post(name: NSNotification.Name("goLogin"), object: "1")
        }else{
             NotificationCenter.default.post(name: NSNotification.Name("goLogin"), object: "2")
        }
        
        
      
        
        }
    
    func closeLeftView() -> Void {
        let navi =  kDelegate?.drawerController?.centerViewController as? MainNaviController
        
        self.evo_drawerController?.setCenter(navi!, withFullCloseAnimation: true, completion: nil)
    }
}




extension LeftViewController{
    func setupUserInfo(id:String?) -> Void {
        if(id == nil){
            return
        }
        let url = SERVER_IP + "/index.php/api/AppInterface/getInfo"
        let parmertas = ["id":id!]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                let nick = data["nickname"] as?String
                self.headView?.nickLabel.text = nick
                
                guard let logo = data["icon"]as?String else{return}
                if(logo.hasPrefix("http")){
                    let url = URL(string: logo)
                    self.headView?.logoView.kf.setImage(with: url)
                }else{
                    let urlStr = SERVER_IP + logo
                    let url = URL(string: urlStr)
                    self.headView?.logoView.kf.setImage(with: url)
                }
                
            }
            
        }

    }
}

extension LeftViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLeftCell, for: indexPath) as? LeftTableViewCell
        
        cell?.accessoryType = .disclosureIndicator
        
        let dic = self.dataSource[indexPath.row]
        let image = dic.keys.first
        let  name = dic.values.first
        cell?.imageView?.image = UIImage(named: image!)
        cell?.nameLabel.text = name
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        closeLeftView()
        NotificationCenter.default.post(name: NSNotification.Name(kSelectFun), object: indexPath)
        
        
        
    }
    
}


