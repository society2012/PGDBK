//
//  HomeViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import MJRefresh

let kHomeNoteCell = "kHomeNoteCell"

class HomeViewController: BaseViewController {

    var homeTable:UITableView?
    var carId:String = "999"
    var page:Int = 1
    lazy var dataSource:[NoteModel] = [NoteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupData()
    }

    func setupTable() -> Void {
        homeTable = UITableView(frame: self.view.bounds, style: .plain)
        homeTable?.tableFooterView = UIView()
        homeTable?.delegate = self
        homeTable?.dataSource = self
        homeTable?.rowHeight = 120
        homeTable?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        homeTable?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        homeTable?.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction:  #selector(loadMoreData))
        
        
        let nib = UINib(nibName: "NoteTableViewCell", bundle: nil)
        homeTable?.register(nib, forCellReuseIdentifier: kHomeNoteCell)
        self.view .addSubview(homeTable!)
    }
    func setupData() -> Void {
        
        let url = SERVER_IP + "/index.php/api/AppInterface/getCatArticle"
        let parmertas:[String:Any] = ["id":self.carId,"page":page,"pagesize":10]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[[String:Any]] else{return}
            let code = dic["code"] as?Int
            self.homeTable?.mj_header.endRefreshing()
            self.homeTable?.mj_footer.endRefreshing()
            if(code == 200){
                if(self.page == 1){
                    self.dataSource.removeAll()
                }
                for dic in data {
                    let model = NoteModel()
                    model.desc = dic["desc"] as?String
                    model.id = dic["id"] as?String
                    model.pic = dic["pic"] as?String
                    model.time = dic["time"] as?String
                    model.title = dic["title"] as?String
                    self.dataSource.append(model)
                    
                }
                self.homeTable?.reloadData()
                
            }

            
            
            
        }

    }

}


extension HomeViewController{
    func loadMoreData() -> Void {
        page = page + 1
        setupData()
    }
    func loadNewData() -> Void {
        page = 1
        setupData()
    }
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
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
}
