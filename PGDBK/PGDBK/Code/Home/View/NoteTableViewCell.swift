//
//  NoteTableViewCell.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/6.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit
import Kingfisher

class NoteTableViewCell: UITableViewCell {
    @IBOutlet var noteImageView: UIImageView!

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var desLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    var newModel:NoteModel?{
        didSet {
        
            self.titleLabel.text = newModel?.title
            self.desLabel.text = newModel?.desc
            
            let time = Int((newModel?.time)!)
            
            let timeStamp:TimeInterval = TimeInterval(time!)
            
            let date = Date(timeIntervalSince1970: timeStamp)
            
            let dformatter = DateFormatter()
            
            dformatter.dateFormat = "MM-dd HH:mm"
            
           let timeOutput = dformatter.string(from: date)
            
            self.timeLabel.text = timeOutput
            
            
            guard  let pic = newModel?.pic else{return}
            let str = SERVER_IP + pic
            let url = URL(string: str)
            self.noteImageView.kf.setImage(with: url!)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
