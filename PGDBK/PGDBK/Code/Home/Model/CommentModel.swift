//
//  CommentModel.swift
//  PGDBK
//
//  Created by hupeng on 2017/7/7.
//  Copyright © 2017年 m.zintao. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    var userId:String?
    var content:String?
    var commentId:String?
    var noteId:String?
    var time:String?
    var nickName:String?
    var icon:String?
    
    
    init(dict:[String:Any]) {
        self.userId = dict["userid"] as?String
        self.content = dict["content"] as?String
        self.commentId = dict["id"] as?String
        self.noteId = dict["articleid"] as?String
        self.time = dict["time"] as?String
        self.nickName = dict["nickname"] as?String
        self.icon = dict["icon"] as?String
    }
    
}
