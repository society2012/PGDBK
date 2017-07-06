
//
//  MemberSexView.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/6.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

protocol MemberSexViewDelegate {
    func sexConfirm(sexH:String) ->Void
}

class MemberSexView: UIView {

    
    var contentView:UIView?
    var selectSex:String = "男"
    var delegate:MemberSexViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
        setupUI()
    }
    
    func setupUI() -> Void {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView = UIView(frame: CGRect(x: 0, y: kScreenH, width: kScreenW, height: 216 + 45))
        contentView?.backgroundColor = UIColor.white
        let accessView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 45))
        accessView.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f7)
        
        
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        cancelBtn.tag = 10
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x666666), for: .normal)
        cancelBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        cancelBtn.setTitle("取消", for: .normal)
        accessView.addSubview(cancelBtn)
        
        
        let confirmBtn = UIButton(frame: CGRect(x: kScreenW - 50, y: 0, width: 50, height: 45))
        confirmBtn.tag = 11
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.setTitleColor(kRGBColorFromHex(rgbValue: 0x666666), for: .normal)
        confirmBtn.setTitle("确定", for: .normal)
        accessView.addSubview(confirmBtn)
        confirmBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        contentView?.addSubview(accessView)
        
        self.addSubview(contentView!)
        
        
        let pickView = UIPickerView(frame: CGRect(x: 0, y: 45, width: kScreenW, height: 216))
        pickView.delegate = self
        pickView.dataSource = self
        contentView?.addSubview(pickView)
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = (touches as NSSet).allObjects.first as!UITouch
        if(first.tapCount == 1){
            self.dismiss()
        }

    }
    
    
   class func sexView() -> MemberSexView {
        let sexView = MemberSexView.init(frame: UIScreen.main.bounds)
        return sexView
    }
    
    func show() -> Void {
        let app = UIApplication.shared.keyWindow
        
        app?.addSubview(self)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 1
            self.contentView?.frame = CGRect(x: 0, y: kScreenH - 216 - 45, width: kScreenW, height: 216 + 45)
        }, completion: nil)
    }
    
    func dismiss() -> Void {
        
        UIView.animate(withDuration: 0.35, animations: {
            self.contentView?.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 216 + 45)
            self.alpha = 0
        }, completion: { (me) in
            self.removeFromSuperview()
        })
        
        
    }
    
    func btnAction(btn:UIButton) -> Void {
         self.dismiss()
        if(btn.tag == 11){
            self.delegate?.sexConfirm(sexH: self.selectSex)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MemberSexView:UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row == 0){
            self.selectSex = "男"
        }
        if(row == 1){
             self.selectSex = "女"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == 0){
            return "男"
        }
        return "女"
    }
}
