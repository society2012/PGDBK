//
//  NoteDetailViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/6.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import SVProgressHUD

class NoteDetailViewController: BaseViewController {

    @IBOutlet var webView: UIWebView!
    var rightBtn:UIButton?
    var tempFild:UITextField?
    var noteId:String = "0"
    lazy var inputTextView:UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 10, width: kScreenW - 20, height: 110))
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.backgroundColor = UIColor.white
        return textView
    }()
    
    lazy var accessView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 160))
        view.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f7)
        view.addSubview(self.inputTextView)
        
        let cancelBtn = UIButton(frame: CGRect(x: 10, y: 160 - 35 , width: 50, height: 30))
        cancelBtn.tag = 10
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.backgroundColor = UIColor.blue
        cancelBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        cancelBtn.setTitle("取消", for: .normal)
        view.addSubview(cancelBtn)
        
        
        let confirmBtn = UIButton(frame: CGRect(x: kScreenW - 60, y: 160 - 35, width: 50, height: 30))
        confirmBtn.tag = 11
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.backgroundColor = UIColor.blue
        confirmBtn.setTitle("确定", for: .normal)
        view.addSubview(confirmBtn)
        confirmBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)

        
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRightBtn()
        commentTapView()
        let urlStr = SERVER_IP + "/index.php/Home/Article/article/id/" + noteId
        let url = URL(string: urlStr)
        self.webView.scrollView.delegate = self
        let request = URLRequest(url: url!)
        self.webView.loadRequest(request)
        isCollected()

        // Do any additional setup after loading the view.
    }
    
    func btnAction(btn:UIButton) -> Void {
        self.inputTextView.resignFirstResponder()
        self.tempFild?.resignFirstResponder()
        if(btn.tag == 11){
            
             let uid = UserDefaults.standard.object(forKey: "userId") as?String
            if(uid == nil){
                SVProgressHUD.showError(withStatus: "请前去登录")
                 return
            }
            
            if(self.inputTextView.text == nil || self.inputTextView.text == ""){
                 SVProgressHUD.showError(withStatus: "评论内容不能为空")
                return
            }
            commentNote()
            
        }
    }
    
    func commentTapView() -> Void {
        let bottomView = UIView(frame: CGRect(x: 0, y: kScreenH - 40 - 64, width: kScreenW, height: 40))
        bottomView.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f7)
        bottomView.isUserInteractionEnabled = true
        self.view.addSubview(bottomView)
        
        
        let label = UILabel(frame: CGRect(x: 20, y: 6, width: kScreenW - 80, height: 26))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = kRGBColorFromHex(rgbValue: 0x999999)
        label.layer.cornerRadius = 12
        label.backgroundColor = UIColor.white
        label.text = "  点击输入评论"
        label.layer.masksToBounds = true
        bottomView.addSubview(label)
        
        
        let btn = UIButton(frame: CGRect(x: kScreenW - 80, y: 0, width: 80, height: 40))
        let image = UIImage(named: "comment.png")
        btn.addTarget(self, action: #selector(commentLsitAction), for: .touchUpInside)
        btn.setImage(image, for: .normal)
        bottomView.addSubview(btn)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushInputView))
        bottomView.addGestureRecognizer(tap)
        
        tempFild = UITextField(frame: CGRect(x: 0, y: kScreenH + 100, width: 100, height: 20))
        tempFild?.inputAccessoryView = self.accessView
        self.view.addSubview(tempFild!)
    }
    
    
    func commentLsitAction() -> Void {
        let commentList = CommentListViewController(nibName: "CommentListViewController", bundle: nil)
        commentList.noteId = self.noteId
        self.navigationController?.pushViewController(commentList, animated: true)
    }
    
    func initRightBtn() -> Void {
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        spaceItem.width = -10
        
        self.rightBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.rightBtn?.addTarget(self, action: #selector(collectionAction(btn:)), for: .touchUpInside)
        
        let selimage = UIImage(named: "collected")
        self.rightBtn?.setImage(selimage, for: .selected)
        let image = UIImage(named: "collect")
        self.rightBtn?.setImage(image, for: .normal)
        
        
        let rightItem = UIBarButtonItem(customView: self.rightBtn!)
        
        self.navigationItem.rightBarButtonItems = [spaceItem,rightItem]

    }
    
    func pushInputView() -> Void {
        tempFild?.becomeFirstResponder()
        self.inputTextView.becomeFirstResponder()
    }
    
    func collectionAction(btn:UIButton) -> Void {
        if(btn.isSelected){
            collectionNote(markStr:"2")
        }else{
            collectionNote(markStr:"1")
        }
    }

}

// MARK:-network
extension NoteDetailViewController{
    
    
    func commentNote() -> Void {
        let url = SERVER_IP + "/index.php/api/AppInterface/comment"
        guard let uid = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        let parmertas:[String:Any] = ["articleid":self.noteId,"userid":uid,"content":self.inputTextView.text!]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            
             self.view.endEditing(true)
            
            guard let dic = response as? [String:Any] else{return}
//            guard let data = dic["data"] as?[String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                self.inputTextView.text = nil
              
                SVProgressHUD.showSuccess(withStatus: "评论成功")
            }else{
                SVProgressHUD.showError(withStatus: "评论失败了")
            }
            
        }

    }
    
    
    func isCollected() -> Void {
        let url = SERVER_IP + "/index.php/api/AppInterface/isCollection"
        guard let uid = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        let parmertas:[String:Any] = ["articleid":self.noteId,"userid":uid]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                let isCollectA = data["isCollection"] as?Int
                if(isCollectA == 1){
                    self.rightBtn?.isSelected = true
                    
                }else{
                     self.rightBtn?.isSelected = false
                }
                
            }
 
        }
        
    }
    
    func collectionNote(markStr:String) -> Void {
        let url = SERVER_IP + "/index.php/api/AppInterface/collection"
        guard let uid = UserDefaults.standard.object(forKey: "userId") as?String else{return}
        let parmertas:[String:Any] = ["articleid":self.noteId,"userid":uid,"mark":markStr]
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            guard let dic = response as? [String:Any] else{return}
            let code = dic["code"] as?Int
            if(code == 200){
                if(markStr == "1"){
                     self.rightBtn?.isSelected = true
                    SVProgressHUD.showSuccess(withStatus: "收藏成功")
                }else{
                    self.rightBtn?.isSelected = false
                    SVProgressHUD.showSuccess(withStatus: "取消收藏成功")
                }
                
            }
            
        }

    }
}


extension NoteDetailViewController:UIWebViewDelegate,UIScrollViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show(withStatus: "加载中")
        SVProgressHUD.setDefaultStyle(.dark)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
