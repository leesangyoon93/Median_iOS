//
//  DetailNoticeViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 23..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit
import SwiftSoup

class DetailNoticeViewController: UIViewController {
    
    var notice: Notice?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    func setUI() {
        self.navigationItem.title = "NOTICE"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_white"), style: .plain, target: self, action: #selector(backButtonTouched))
        
        contentLabel.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        contentLabel.layer.borderWidth = 1.0
        contentLabel.layer.cornerRadius = 5
        
        titleLabel.text = notice?.title
        do {
            let str = try NSAttributedString(data: getHtmlText().data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            contentLabel.text = str.string
        } catch {
            print(error)
        }
    }
    
    private func getHtmlText() -> String {
        do{
            let doc: Document = try SwiftSoup.parseBodyFragment(((notice?.contents)!))
            return try (doc.body()?.html())!
        }catch {
        }
        return ""
    }
    
    func backButtonTouched() {
        self.dismiss(animated: true, completion: nil)
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
