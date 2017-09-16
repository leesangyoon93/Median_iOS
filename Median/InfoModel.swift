//
//  InfoModel.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Firebase

class InfoModel: NSObject {
    private var infos = [Information]()
    var infoLoadDelegate: InfoLoadDelegate?
    
    func loadInfo() {
        let ref = FIRDatabase.database().reference()
        let infoRef = ref.child("info")
        
        infoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.infos.removeAll()
            if let dic = snapshot.value as? [String: AnyObject] {
                
                for(_, value) in dic {
                    let info = Information(name: value["name"] as? String,
                                           email: value["email"] as? String,
                                           tel: value["telNumber"] as? Int,
                                           office: value["location"] as? String,
                                           profileImage: value["profileImage"] as? String)
                    self.infos.append(info)
                }
                self.sortInfo()
                self.infoLoadDelegate?.didLoad(self.infos)
            }
        })
    }
    
    private func sortInfo() {
        infos.sort { (info1, info2) -> Bool in
            return info1.name! > info2.name!
        }
    }
}
