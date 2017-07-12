//
//  SearchViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/7.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: BaseViewController {

    @IBOutlet var searchTable: UITableView!
    var inputFild:UITextField?
    lazy var dataSource:[NoteModel] = [NoteModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTable.rowHeight = 120
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        searchTable?.register(nib, forCellReuseIdentifier: kHomeNoteCell)

        self.searchTable.tableFooterView = UIView()
        setupUI()

    }
    
    func setupUI() -> Void {
        let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenW - 120, height: 30))
        bgView.isUserInteractionEnabled = true
        var image = UIImage(named: "search")
        let insert = UIEdgeInsetsMake(10, 30, 10, 10)
        image = image!.resizableImage(withCapInsets: insert)
        bgView.image = image
        self.navigationItem.titleView = bgView
        
        
        inputFild = UITextField(frame: CGRect(x: 30, y: 5, width: bgView.frame.width - 40, height: 20))
        inputFild?.placeholder = "请输入搜索内容"
        inputFild?.font = UIFont.systemFont(ofSize: 14)
        inputFild?.delegate = self
        inputFild?.becomeFirstResponder()
        inputFild?.clearButtonMode = .whileEditing
        inputFild?.returnKeyType = .search
        bgView.addSubview(inputFild!)
        
        
    }
    
    override func leftAction() {
        self.inputFild?.resignFirstResponder()
        super.leftAction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
}


extension SearchViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let key = textField.text
        if(key == nil || key == ""){
            SVProgressHUD.showError(withStatus: "请输入搜索内容")
            return true
        }
        searchNote(key: key!)
        return true
    }
    
    func searchNote(key:String) -> Void {
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.setDefaultStyle(.dark)
        let url = SERVER_IP + "/index.php/api/AppInterface/searchArticle"
        let parmertas:[String:Any] = ["key":key]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            SVProgressHUD.dismiss()
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[[String:Any]] else{return}
            let code = dic["code"] as?Int
        
            if(code == 200){
                
                for dic in data {
                    let model = NoteModel()
                    model.desc = dic["desc"] as?String
                    model.id = dic["id"] as?String
                    model.pic = dic["pic"] as?String
                    model.time = dic["time"] as?String
                    model.title = dic["title"] as?String
                    self.dataSource.append(model)
                    
                }
                self.searchTable?.reloadData()
                
            }
 
        }
        
    }

}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.inputFild?.resignFirstResponder()
    }
}



