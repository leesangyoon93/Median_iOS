//
//  NoticeModel.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 24..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Foundation
import Firebase

class NoticeModel {
    var notices = [Notice]()
    var noticeChangeDelegate: NoticeChangeDelegate?
    
    func loadNotice() {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child("media_notice")
        
        postRef.observe(.value, with: { (snapshot) in
            self.notices.removeAll()
            if let dic = snapshot.value as? [String: AnyObject] {
                for(_, value) in dic {
                    let contents = value["contents"] as! String
                    let notice = Notice(title: value["title"] as? String, contents: contents, boardNum: value["boardNum"] as? Int)
                    self.notices.append(notice)
                }
                self.sortNotice()
                
                self.noticeChangeDelegate?.didChange(self.notices)
            }
            else {
                self.noticeChangeDelegate?.didChange(self.notices)
            }
        })
    }
    
    private func sortNotice() {
        notices.sort { (notice1, notice2) -> Bool in
            return notice1.boardNum! > notice2.boardNum!
        }
    }
}
