//
//  CommentLoadDelegate.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Foundation

protocol CommentLoadDelegate {
    func didLoad(_ comments: [Comment])
    func didWrite()
    func didFail()
}
