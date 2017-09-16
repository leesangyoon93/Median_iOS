//
//  DetailPostViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit

class DetailPostViewController: UIViewController, CommentLoadDelegate, PostEditDelegate {
    
    var postType: String?
    var post: Post?
    var comments = [Comment]()
    let postModel = PostModel()
    let commentModel = CommentModel()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        commentModel.commentLoadDelegate = self
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        setUI()
        commentModel.loadComment(from: (post?.key)!)
    }
    
    func didLoad(_ comments: [Comment]) {
        self.comments = comments
        self.navigationItem.title = (post?.author)! + " (\(comments.count))"
        commentTableView.reloadData()
    }
    
    @IBAction func commentTouched(_ sender: Any) {
        if commentTextField.text != "" {
            commentModel.write((post?.key)!, postType!, commentTextField.text!)
        }
        else {
            showAlertDialog(title: "댓글입력", message: "댓글을 입력해주세요")
        }
    }
    
    func didWrite() {
        commentTextField.text = ""
    }
    
    func didFail() {
        showAlertDialog(title: "게시오류", message: "존재하지 않는 게시물입니다.")
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUI() {
        self.navigationItem.title = (post?.author)! + " (\(comments.count))"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_white"), style: .plain, target: self, action: #selector(backButtonTouched))
        
        contentLabel.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        contentLabel.layer.borderWidth = 1.0
        contentLabel.layer.cornerRadius = 5
        
        if post?.authorUid! == UserDefaults.standard.object(forKey: "uid") as? String {
            let removeItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(removePostTouched))
            let editItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editPostTouched))
            
            self.navigationItem.rightBarButtonItems = [editItem, removeItem]
        }
        commentTextField.becomeFirstResponder()
        
        titleLabel.text = post?.title
        contentLabel.text = post?.contents
    }
    
    func removePostTouched() {
        self.postModel.remove(self.postType!, (post?.key)!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func editPostTouched() {
        self.performSegue(withIdentifier: "EditPostSegue", sender: nil)
    }
    
    func backButtonTouched() {
        self.dismiss(animated: true, completion: nil)
    }

    func didEdit(_ post: Post) {
        self.post = post
        titleLabel.text = post.title
        contentLabel.text = post.contents
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPostSegue" {
            let editVC = (segue.destination as! WritePostNavigationController).viewControllers.first as! WritePostViewController
            editVC.postType = self.postType
            editVC.postEditDelegate = self
            editVC.post = self.post!
        }

    }
    
    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension DetailPostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        if comments.count > 0 {
            cell.titleLabel.text = comments[indexPath.row].author! + " (\(comments[indexPath.row].timestamp!))"
            cell.subtitleLabel.text = "\(comments[indexPath.row].contents!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if comments[indexPath.row].authorUid == UserDefaults.standard.object(forKey: "uid") as? String {
            let deleteAction = UITableViewRowAction(style: .normal, title: "삭제") { (action, index) in
                self.commentModel.remove(self.postType!, (self.post?.key)!, self.comments[indexPath.row].key!)
            }
            return [deleteAction]
        }
        return []
    }

}
