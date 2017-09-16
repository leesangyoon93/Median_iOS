//
//  CommentModel.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Firebase

class CommentModel: NSObject {
    var comments = [Comment]()
    var commentLoadDelegate: CommentLoadDelegate?
    
    func loadComment(from: String) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child("comments").child(from)
        
        postRef.observe(.value, with: { (snapshot) in
            self.comments.removeAll()
            if let dic = snapshot.value as? [String: AnyObject] {
                for(key, value) in dic {
                    let comment = Comment(key: key,
                                          authorUid: value["uid"] as? String,
                                          author: value["author"] as? String,
                                          contents: value["text"] as? String,
                                          timestamp: self.timeToString(value["timeStamp"] as! Int))
                    self.comments.append(comment)
                }
                self.sortComment()
                self.commentLoadDelegate?.didLoad(self.comments)
            }
            else {
                self.commentLoadDelegate?.didLoad(self.comments)
            }
        })
    }
    
    func write(_ key: String, _ postType: String, _ content: String) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(postType).child(key)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject] {
                let commentRef = ref.child("comments").child(key).childByAutoId()
                let commentData = ["author": UserDefaults.standard.object(forKey: "name") as! String,
                                   "uid": UserDefaults.standard.object(forKey: "uid") as! String,
                                   "text": content, "timeStamp": self.getTimestamp()] as [String: Any]
                commentRef.updateChildValues(commentData)
                postRef.updateChildValues(["commentCount": dic["commentCount"] as! Int + 1])
                
                self.commentLoadDelegate?.didWrite()
            }
            else {
                self.commentLoadDelegate?.didFail()
            }
        })
    }
    
    func remove(_ postType: String, _ postKey: String, _ commentKey: String) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(postType).child(postKey)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject] {
                let commentRef = ref.child("comments").child(postKey).child(commentKey)
                commentRef.removeValue()
                postRef.updateChildValues(["commentCount": dic["commentCount"] as! Int - 1])
                
                self.commentLoadDelegate?.didWrite()
            }
            else {
                self.commentLoadDelegate?.didFail()
            }
        })
        
    }
    
    private func timeToString(_ time: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd HH:mm:ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: Double(time) / 1000))
    }
    
    private func getTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970 * 1000)
    }
    
    private func sortComment() {
        comments.sort { (comment1, comment2) -> Bool in
            return comment1.timestamp! < comment2.timestamp!
        }
    }
}
