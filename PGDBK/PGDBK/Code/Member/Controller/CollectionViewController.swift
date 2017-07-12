//
//  CollectionViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/7.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import SVProgressHUD

class CollectionViewController: BaseViewController {

    lazy var defaultLabel:UILabel = {
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: kScreenW, height: 20))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        label.textColor = kRGBColorFromHex(rgbValue: 0x666666)
        label.text = "还没有任何收藏！"
        return label
        }()
    
    var dataSource:[NoteModel] = [NoteModel]()
    var index :Int = 0
    @IBOutlet var theTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的收藏"
        self.theTable.rowHeight = 120
        self.theTable.tableFooterView = UIView()
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        theTable?.register(nib, forCellReuseIdentifier: kHomeNoteCell)
        setupData()

    }

    func setupData() -> Void {
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.setDefaultStyle(.dark)
       
        guard let uid = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        let parmertas:[String:Any] = ["userid":uid]
         let url = SERVER_IP + "/index.php/api/AppInterface/collectionList"
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            SVProgressHUD.dismiss()
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[[String:Any]] else{return}
            if(data.count == 0){
                self.defaultLabel.isHidden = false
                self.view.addSubview(self.defaultLabel)
            }
            let code = dic["code"] as?Int
            if(code == 200){
                for dic in data {
                    let model = NoteModel()
                    model.desc = dic["desc"] as?String
                    model.id = dic["articleid"] as?String
                    model.pic = dic["pic"] as?String
                    model.time = dic["time"] as?String
                    model.title = dic["title"] as?String
                    model.collectId = dic["id"]as?String
                    self.dataSource.append(model)
                }
                self.theTable?.reloadData()
            }
        }
    }
    
    func cancelCollection() -> Void {
        let model = self.dataSource[self.index]
        let url = SERVER_IP + "/index.php/api/AppInterface/collection"
        guard let uid = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        let parmertas:[String:Any] = ["articleid":model.id!,"userid":uid,"mark":"2"]
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                self.dataSource.remove(at: self.index)
                self.theTable.reloadData()
                SVProgressHUD.showSuccess(withStatus: "取消收藏成功")
                
            }
            
        }

    }
}


extension CollectionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        let detail = NoteDetailViewController(nibName: "NoteDetailViewController", bundle: nil)
        detail.noteId = model.id!
        self.navigationController?.pushViewController(detail, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kHomeNoteCell, for: indexPath) as?NoteTableViewCell
        cell?.newModel  = self.dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "取消收藏"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        self.index = indexPath.row
      
        if(editingStyle == .delete){
            cancelCollection()
        }
    }
}

