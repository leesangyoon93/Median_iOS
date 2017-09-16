//
//  PostModel.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Firebase

class PostModel: NSObject {
    var posts = [Post]()
    var postChangeDelegate: PostChangeDelegate?
    var postUploadDelegate: PostUploadDelegate?
    
    func loadPost(from: String) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(from)
        
        postRef.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            if let dic = snapshot.value as? [String: AnyObject] {
                for(key, value) in dic {
                    var urlList: [String] = [String]()
                    print(value["urlList"] as? [String: Any])
                    if value["urlList"] as? [String: Any] != nil {
                        
                    }
                    let post = Post(key: key,
                                    title: value["title"] as? String,
                                    contents: value["contents"] as? String,
                                    author: value["author"] as? String,
                                    timestamp: self.timeToString(value["timeStamp"] as! Int),
                                    authorUid: value["authorUid"] as? String,
                                    commentCount: value["commentCount"] as? Int,
                                    urlList: urlList)
                    self.posts.append(post)
                }
                self.sortPost()
                self.postChangeDelegate?.didChange(self.posts)
            }
            else {
                self.postChangeDelegate?.didChange(self.posts)
            }
        })
    }
    
    func uploadImages(_ images: [UIImage]) {
        let storage = FIRStorage.storage().reference()
        let ref = storage.child("postImages").child("\(getTimestamp())")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        var count = 0
        var urlList = [String]()
        
        for image in images {
            if let uploadData = UIImageJPEGRepresentation(image, 0.5) {
                ref.put(uploadData, metadata: metadata, completion: { (metadata, error) in
                    count = count + 1
                    
                    urlList.append((metadata?.name)!)
                    
                    if(count >= images.count) {
                        self.postUploadDelegate?.didUpload(urlList)
                    }
                })
            }
        }
    }
    
    func write(_ postType: String, _ title: String, _ content: String, _ urlList: [String]) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(postType).childByAutoId()
        let postData = ["author": UserDefaults.standard.object(forKey: "name") as! String,
                        "authorUid": UserDefaults.standard.object(forKey: "uid") as! String,
        "title": title, "contents": content, "timeStamp": getTimestamp(), "commentCount": 0] as [String : Any]
        
        let imageRef = ref.child(postType).child(postRef.key).child("urlList")

        for url in urlList {
            imageRef.updateChildValues(["\(urlList.index(of: url)!)": url])
        }
        
        postRef.updateChildValues(postData) { (error, ref) in
            self.postUploadDelegate?.didWrite()
        }
        
    }
    
    func edit(_ postType: String, _ post: Post) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(postType).child(post.key!)
        let updatePostData = ["title": post.title!, "contents": post.contents!]
        postRef.updateChildValues(updatePostData) { (error, ref) in
            self.postUploadDelegate?.didEdit(post)
        }
    }
    
    func remove(_ postType: String, _ key: String) {
        let ref = FIRDatabase.database().reference()
        let postRef = ref.child(postType).child(key)
        postRef.removeValue()
        
        let commentRef = ref.child("comments").child(key)
        commentRef.removeValue()
    }
    
    private func sortPost() {
        posts.sort { (post1, post2) -> Bool in
            return post1.timestamp! < post2.timestamp!
        }
    }
    
    private func timeToString(_ time: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd HH:mm:ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: Double(time) / 1000))
    }
    
    private func getTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970 * 1000)
    }
}
