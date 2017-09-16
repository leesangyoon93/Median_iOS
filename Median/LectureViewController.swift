//
//  LectureViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 25..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController {
    
    let lectureRoom = ["415, 419, 420, 421, 422, 422-1"]
    let time = ["A(09:00~10:15)", "B(10:30~11:45", "C(12:00~13:15", "D(13:30~14:45", "E(15:00~16:15", "F(16:30~17:45", "G(18:00~19:15)", "19:30~"]
    let lecture = ["디자인기초", "", "", "컴퓨터그래픽스", "객체지향프로그래밍", "", "", "디지털사운드기초"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.navigationItem.title = "강의시간표"
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
