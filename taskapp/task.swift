//
//  task.swift
//  taskapp
//
//  Created by 山崎大聖 on 2017/03/31.
//  Copyright © 2017年 山崎大聖. All rights reserved.
//


import RealmSwift

class Task: Object {
    
    dynamic var category = ""
    // 管理用 ID。プライマリーキー
    dynamic var id = 0
    
    // タイトル
    dynamic var title = ""
    
    // 内容
    dynamic var contents = ""
    
    /// 日時
    dynamic var date = NSDate()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
