//
//  CommentTableViewCell.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/7.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconView.layer.cornerRadius = 45/2
        self.iconView.layer.masksToBounds = true
    }
    
    var newModel:CommentModel?{
        didSet {
            self.nickNameLabel.text = newModel?.nickName
            self.contentLabel.text = newModel?.content
            let time = Int((newModel?.time)!)
            
            let timeStamp:TimeInterval = TimeInterval(time!)
            
            let date = Date(timeIntervalSince1970: timeStamp)
            
            let dformatter = DateFormatter()
            
            dformatter.dateFormat = "MM-dd HH:mm"
            
            let timeOutput = dformatter.string(from: date)
            
            self.timeLabel.text = timeOutput
            
            guard  let logo = newModel?.icon else{return}
            if(logo.hasPrefix("http")){
                let url = URL(string: logo)
                self.iconView.kf.setImage(with: url)
            }else{
                let urlStr = SERVER_IP + logo
                let url = URL(string: urlStr)
                self.iconView.kf.setImage(with: url)
            }
            


            
        }
    
    }
    



   class func getCellHeight(model:CommentModel) -> CGFloat {
        let labelC = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenW - 75, height: 20))
        labelC.text = model.content
        labelC.numberOfLines = 0
        labelC.font = UIFont.systemFont(ofSize: 14)
        labelC.sizeToFit()
        return 40 + labelC.frame.height + 20
    }
    
}
