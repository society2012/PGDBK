//
//  LoginViewController.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

import SVProgressHUD


class LoginViewController: BaseViewController {
    @IBOutlet var passwordFild: UITextField!

    @IBOutlet var userNameFild: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = UserDefaults.standard.object(forKey: "userName") as?String
        let pwd = UserDefaults.standard.object(forKey: "passWord") as?String
        self.userNameFild.text = name
        self.passwordFild.text = pwd

    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(registerVC, animated: true)
        
    }
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if(self.userNameFild.text == nil){
            let alert = UIAlertView(title: "提示", message: "用户名不能为空", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        if(self.passwordFild.text == nil){
            let alert = UIAlertView(title: "提示", message: "密码不能为空", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        goLogin()
        

    }
    
    func goLogin() -> Void {
        
        SVProgressHUD.show(withStatus: "登录中")
        SVProgressHUD.setDefaultStyle(.dark)
        
        let url = SERVER_IP + "/index.php/api/AppInterface/loginApp"
        let parmertas = ["username":self.userNameFild.text!,"password":self.passwordFild.text!]
        
        NetWorkTools.requestData(URLString: url, type: .post, parmertas: parmertas) { (response) in
            SVProgressHUD.dismiss()
            guard let dic = response as? [String:Any] else{return}
            guard let data = dic["data"] as?[String:Any] else{return}
            let code = dic["code"] as?Int
            let message = dic["message"] as?String
            if(code == 200){
                let id = data["id"] as?String
                UserDefaults.standard.set(id, forKey: "userId")
                UserDefaults.standard.set(self.userNameFild.text, forKey: "userName")
                 UserDefaults.standard.set(self.passwordFild.text, forKey: "passWord")
                NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: id)
                self.navigationController?.popViewController(animated: true)
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

        
        
        
//        for touch: AnyObject in touches{
//             let tap:UITouch = touch as! UITouch
//            if(tap.tapCount == 1){
//                self.view.endEditing(true)
//            }
//        }
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
