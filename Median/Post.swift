//
//  User.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Foundation

struct Post {
    let key: String?
    var title: String?
    var contents: String?
    let author: String?
    let timestamp: String?
    let authorUid: String?
    var commentCount: Int?
    var urlList = [String]()
    
    private func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    mutating func setCommentCount(_ count: Int) {
        self.commentCount = count
    }
    
    mutating func setTitle(_ title: String) {
        self.title = title
    }
    
    mutating func setContents(_ contents: String) {
        self.contents = contents
    }
    
    mutating func setUrlList(_ urlList: [String]) {
        self.urlList = urlList
    }
}
