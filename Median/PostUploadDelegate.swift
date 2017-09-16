//
//  PostWriteDelegate.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Foundation

protocol PostUploadDelegate {
    func didWrite()
    func didEdit(_ post: Post)
    func didUpload(_ urlList: [String])
}
