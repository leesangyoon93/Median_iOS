//
//  NoticeChangeDelegate.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 24..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import Foundation

protocol NoticeChangeDelegate {
    func didChange(_ notices: [Notice])
}
