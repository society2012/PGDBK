//
//  TitleView.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/7.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit


protocol TitleViewDelegate {
    func  titleViewBtnClick(index:Int) -> Void
}

class TitleView: UIView {

    var bgScroView:UIScrollView?
    var line:UIView?
    var delegate:TitleViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kRGBColorFromHex(rgbValue: 0xf2f4f9)
        bgScroView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 1))
        bgScroView?.backgroundColor = UIColor.clear
        bgScroView?.showsVerticalScrollIndicator = false
        bgScroView?.showsHorizontalScrollIndicator = false
        self.addSubview(bgScroView!)
        
        
        line = UIView(frame: CGRect(x: 20, y:(bgScroView?.frame.height)! - 1 , width: 40, height: 1))
        line?.backgroundColor = UIColor.red
        
        bgScroView?.addSubview(line!)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: frame.height  - 0.5, width: kScreenW, height: 0.5))
        bottomLine.backgroundColor = kRGBColorFromHex(rgbValue: 0x999999)
        self.addSubview(bottomLine)
    }
    
    var titleS:[CatModel]?{
      
        didSet {
            var i = 0
            let count = titleS?.count
            bgScroView?.contentSize = CGSize(width: 80 * count!, height: Int((bgScroView?.frame.height)!))
            for model in titleS! {
                let btn = UIButton(frame: CGRect(x: 80 * i , y: 0, width: 80, height: Int((bgScroView?.frame.height)!)))
                btn.setTitle(model.catName, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.setTitleColor(kRGBColorFromHex(rgbValue: 0x666666), for: .normal)
                btn.tag = 10 + i
                btn.backgroundColor = UIColor.clear
                btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
                bgScroView?.addSubview(btn)
                i += 1
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnAction(btn:UIButton) -> Void {
        
        
      self.delegate?.titleViewBtnClick(index: btn.tag - 10)
        
       moveLine(index: btn.tag - 10)
        
    }
    
    
    
    func moveLine(index:Int) -> Void {
        
        let btn = bgScroView?.viewWithTag(index + 10) as?UIButton
        
        var offset = btn!.center.x - self.frame.width/2
        if(offset < 0){
            offset = 0.0
        }
        let maxOffset = (self.bgScroView?.contentSize.width)! - self.frame.width
        if(offset > maxOffset){
            offset = maxOffset
        }
        
        let point = CGPoint(x: offset, y: 0)
        
        self.bgScroView?.setContentOffset(point, animated: true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.line?.center = CGPoint(x: btn!.center.x, y: self.line!.center.y)
        }) { (yes) in
        }
    }

}
