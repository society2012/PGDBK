//
//  RegisterViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterViewController: BaseViewController {

    @IBOutlet var confirmFild: UITextField!
    @IBOutlet var pwdFild: UITextField!
    @IBOutlet var userNameFild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.title = "注册"

        // Do any additional setup after loading the view.
    }

    @IBAction func registerAction(_ sender: UIButton) {
        
        if(self.userNameFild.text == nil || self.userNameFild.text == ""){
            
            SVProgressHUD.showError(withStatus: "用户名不能为空")
            return

        }
        if(self.pwdFild.text == nil || self.pwdFild.text == ""){
            SVProgressHUD.showError(withStatus: "密码不能为空")

            return
        }
        if(self.confirmFild.text == nil || self.confirmFild.text == ""){
            SVProgressHUD.showError(withStatus: "确认密码不能为空")

            return
        }
        
        if(self.pwdFild.text != self.confirmFild.text){
            SVProgressHUD.showError(withStatus: "两次输入的密码不同")

            return
        }
        
        goRegister()


        
    }
   
    
    func goRegister() -> Void {
        SVProgressHUD.show(withStatus: "注册中")
        SVProgressHUD.setDefaultStyle(.dark)
        
        let url = SERVER_IP + "/index.php/api/AppInterface/registerApp"
        let parmertas = ["username":self.userNameFild.text!,"password":self.pwdFild.text!]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            SVProgressHUD.dismiss()
            guard let data = response as? [String:Any] else{return}
            let code = data["code"] as?Int
            let message = data["message"] as?String
            if(code == 200){
              SVProgressHUD.showSuccess(withStatus: "注册成功")
            }else{
                SVProgressHUD.showError(withStatus: message)
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = (touches as NSSet).allObjects.first as!UITouch
        if(first.tapCount == 1){
            self.view.endEditing(true)
        }
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
