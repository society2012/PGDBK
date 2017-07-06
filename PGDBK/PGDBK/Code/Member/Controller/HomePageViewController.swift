//
//  HomePageViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

let kHomeCell = "kHomeCell"

class HomePageViewController: BaseViewController {

    @IBOutlet var homeTable: UITableView!
    var iconView:UIImageView?
    var nickName:String = "默认一个昵称"
    var sex :String = "男"
    var sign :String = "请签名"
    
    var logoImage : UIImage?
    
    lazy var accessView:UIView = {
    
        return UIView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f9)
        setupUI()
        setupUserInfo()
        
    }
    func setupUI() -> Void {
        self.homeTable.rowHeight = 45
        let nib = UINib(nibName: "MemberTableViewCell", bundle: nil)
        self.homeTable.register(nib, forCellReuseIdentifier: kHomeCell)
        self.homeTable.tableFooterView = UIView()
        
        let headView = UIView()
        headView.backgroundColor = UIColor.white
        headView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 120)
        iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        iconView?.layer.masksToBounds = true
        iconView?.layer.cornerRadius = 35
        iconView?.contentMode = .scaleAspectFill
        iconView?.center = headView.center
        iconView?.image = UIImage(named: "defaultIcon.png")
        headView.addSubview(iconView!)
        iconView?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(headTap))
        iconView?.addGestureRecognizer(tap)
        
        self.homeTable.tableHeaderView = headView

    }
    
//    func accessView() -> Void {
//        
//    }
    
    func headTap() -> Void {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle:  "取消", destructiveButtonTitle: nil, otherButtonTitles:"相册","相机")
        actionSheet.show(in: self.view)
    }

}

extension HomePageViewController:UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kHomeCell, for: indexPath) as?MemberTableViewCell
        cell?.index = indexPath
        if(indexPath.row == 0){
            cell?.titleLabel.text = "昵称"
            cell?.valueFild.text = self.nickName
        }
        if(indexPath.row == 1){
            cell?.valueFild.isUserInteractionEnabled = false
            cell?.titleLabel.text = "性别"
            cell?.valueFild.text = self.sex
        }

        if(indexPath.row == 2){
            cell?.titleLabel.text = "签名"
            cell?.valueFild.text = self.sign
        }
        cell?.delegate = self
        cell?.accessoryType = .disclosureIndicator

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 1){
            let sexView = MemberSexView.sexView()
            sexView.delegate = self
            
            sexView.show()
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
    
        openAlbumOrCamera(type: buttonIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let first = (touches as NSSet).allObjects.first as!UITouch
        if(first.tapCount == 1){
            self.view.endEditing(true)
        }
    }


    
    
}

extension HomePageViewController{

    func openAlbumOrCamera(type:Int) -> Void {//1 相册  2 相机
        if(type == 0){
            return
        }
        var sourceType = UIImagePickerControllerSourceType.photoLibrary
        if(type == 1){
            sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        if(type == 2){
            sourceType = UIImagePickerControllerSourceType.camera
            if(UIImagePickerController.isSourceTypeAvailable(sourceType)){
            }else{
                print("相机不可用")
                return
            }
        }
        
        let imagePick = UIImagePickerController()
        imagePick.sourceType = sourceType
        imagePick.mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType)!
        imagePick.allowsEditing = true
        imagePick.delegate = self
        self.present(imagePick, animated: true, completion: nil)
        
        
        
    }
}

extension HomePageViewController:MemberTableViewCellDelegate,MemberSexViewDelegate{
    
    // MARK:-性别修改
    func sexConfirm(sexH: String) {
        self.changeInfo(key: "sex", value: sexH)
        self.sex = sexH
        let index = IndexPath(row: 1, section: 0)
        self.homeTable.reloadRows(at: [index], with: .middle)

    }
    
    func memberCellBtnAction(indexPath: IndexPath, tag: Int,value:String?) {
        self.view.endEditing(true)
        if(tag == 10){
            self.homeTable.reloadData()
            return
        }
        if(tag == 11){
            if(value == nil){
                let alert = UIAlertView(title: "提示", message: "内容不能为空", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                return
            }
            if(indexPath.row == 0){
                changeInfo(key: "nickname", value: value!)
                
                let index = IndexPath(row: 0, section: 0)
                self.nickName = value!
                self.homeTable.reloadRows(at: [index], with: .fade)
            }
            if(indexPath.row == 2){
                changeInfo(key: "sign", value: value!)
                self.sign = value!
                let index = IndexPath(row: 2, section: 0)
                
                self.homeTable.reloadRows(at: [index], with: .middle)
            }
        }
    }
}

extension HomePageViewController{
    func setupUserInfo() -> Void {

        guard let id = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        
        let url = SERVER_IP + "/index.php/api/AppInterface/getInfo"
        let parmertas = ["id":id]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                
                guard  let nick = data["nickname"] as?String else{return}
                self.nickName = nick
                guard  let sex = data["sex"] as?String else{return}
                self.sex = sex
                guard let sign = data["sign"]as?String else{return}
                self.sign = sign
                guard let logo = data["icon"]as?String else{return}
                if(logo.hasPrefix("http")){
                    let url = URL(string: logo)
                    self.iconView?.kf.setImage(with: url)
                }else{
                    let urlStr = SERVER_IP + logo
                    let url = URL(string: urlStr)
                    self.iconView?.kf.setImage(with: url)
                }
                self.homeTable.reloadData()
                
            }
            
        }
        
    }
    
    
    func changeInfo(key:String,value:String) -> Void {
        guard let id = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        
        let url = SERVER_IP + "/index.php/api/AppInterface/changeinfo"
        let parmertas = ["id":id,key:value]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
//            guard let data = dic["data"] as?[String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                
                if(key == "nickname"){
                    NotificationCenter.default.post(name: NSNotification.Name("changeInfo"), object: value)
                }

                
            }
            
        }

    }
    
    func uploadLogo(imageData:Data) -> Void {
        
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.setDefaultStyle(.dark)
        
         let url = SERVER_IP + "/index.php/api/AppInterface/uploadImage"
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            //uid只有这样能给到服务器
                let id = UserDefaults.standard.object(forKey: "userId") as?String
                let data = id?.data(using: .utf8)
                multipartFormData.append(data!, withName: id!, fileName: id!, mimeType: "text/json")
                let fileName = String(Date().timeIntervalSince1970) + ".jpeg"
                multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/jpeg")
                
        },to: url,encodingCompletion: { encodingResult in
            
            SVProgressHUD.dismiss()
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                guard   let dic = response.result.value as?[String:Any] else{return}
                    
                let code = dic["code"] as?Int

                if(code == 200){
                    self.iconView?.image  = self.logoImage
                    SVProgressHUD.showSuccess(withStatus: "上次成功")
                    
                }
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        )
    }

}


extension HomePageViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         picker.dismiss(animated: true, completion: nil)
        guard  let image = info["UIImagePickerControllerEditedImage"] as?UIImage else{return}
        
        self.logoImage = image
        
        let data = UIImageJPEGRepresentation(image, 0.5)
        
        uploadLogo(imageData: data!)
        
         NotificationCenter.default.post(name: NSNotification.Name("changeInfo"), object: image)
        
        print(info)
    }
    
}
