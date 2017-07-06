//
//  MemberTableViewCell.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/6.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit


protocol MemberTableViewCellDelegate {
    func memberCellBtnAction(indexPath:IndexPath,tag:Int,value:String?) -> Void
}

class MemberTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueFild: UITextField!
    var index:IndexPath?
    var delegate:MemberTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

        self.valueFild.inputAccessoryView = accessView
        
    }
    
    func btnAction(btn:UIButton) -> Void {
        
        self.delegate?.memberCellBtnAction(indexPath: index!, tag: btn.tag,value:self.valueFild.text)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
