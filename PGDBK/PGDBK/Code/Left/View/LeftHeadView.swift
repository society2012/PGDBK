//
//  LeftHeadView.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/5.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class LeftHeadView: UIView {

    @IBOutlet var logoView: UIImageView!

    @IBOutlet var nickLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoView.layer.cornerRadius = 35
        self.logoView.layer.masksToBounds = true
    }
    

}
