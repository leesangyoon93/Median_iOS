//
//  WritePostViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit
import ImagePicker

class WritePostViewController: UIViewController, PostUploadDelegate, ImagePickerDelegate {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let imagePickerController = ImagePickerController()
    
    var images =  [UIImage]()
    var post: Post?
    var postType: String?
    let postModel = PostModel()
    var postEditDelegate: PostEditDelegate?
    
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postModel.postUploadDelegate = self
        contentTextField.delegate = self
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imagePickerController.delegate = self
        
        setUI()
    }
    
    func setUI() {
        self.navigationItem.title = "게시물 업로드"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_white"), style: .plain, target: self, action: #selector(backButtonTouched))
        
        
        contentTextField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        contentTextField.layer.borderWidth = 1.0
        contentTextField.layer.cornerRadius = 5
        
        if post == nil {
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(writePostTouched)),
                UIBarButtonItem(title: "사진", style: .plain, target: self, action: #selector(addImageTouched))]

            contentTextField.text = "내용을 입력해주세요"
            contentTextField.textColor = UIColor.lightGray
        }
        else {
            self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editPostTouched)),
            UIBarButtonItem(title: "사진", style: .plain, target: self, action: #selector(addImageTouched))]
                
            titleTextField.text = (post?.title)!
            contentTextField.text = (post?.contents)!
        }
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        titleTextField.becomeFirstResponder()
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.images = images
        imageCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func addImageTouched() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func backButtonTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func writePostTouched() {
        if titleTextField.text != "" && contentTextField.text != "" {
            if images.count > 0 {
                postModel.uploadImages(images)
            } else {
                postModel.write(postType!, titleTextField.text!, contentTextField.text!, [String]())
            }
        }
        else {
            showAlertDialog(title: "게시물 입력", message: "게시물 내용을 입력해주세요.")
        }
    }
    
    func didUpload(_ urlList: [String]) {
        print("upload")
        postModel.write(postType!, titleTextField.text!, contentTextField.text!, urlList)
    }
    
    func editPostTouched() {
        if titleTextField.text != "" && contentTextField.text != "" {
            post?.setTitle(titleTextField.text!)
            post?.setContents(contentTextField.text!)
            postModel.edit(postType!, post!)
        }
        else {
            showAlertDialog(title: "오류", message: "게시물 내용을 입력해주세요.")
        }
    }
    
    func didWrite() {
        showAlertDialog(title: "게시완료", message: "게시물 등록이 완료되었습니다.")
    }
    
    func didEdit(_ post: Post) {
        self.post = post
        showAlertDialog(title: "수정완료", message: "게시물 수정이 완료되었습니다.")
        postEditDelegate?.didEdit(post)
    }

    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if title != "오류" {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
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

extension WritePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextField.textColor == UIColor.lightGray {
            contentTextField.text = nil
            contentTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextField.text.isEmpty {
            contentTextField.text = "내용을 입력해주세요"
            contentTextField.textColor = UIColor.lightGray
        }
    }
}

extension WritePostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCell", for: indexPath) as! PostImageCollectionViewCell
        
        cell.imgView.image = images[indexPath.row]
        return cell
    }
}
