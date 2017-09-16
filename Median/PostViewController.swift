//
//  PostTableViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, PostChangeDelegate {
    
    var postType: String = "student_notice"
    var posts = [Post]()
    var filterPosts = [Post]()
    let postModel = PostModel()
    
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var postSegment: UISegmentedControl!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.dataSource = self
        postTableView.delegate = self
        postModel.postChangeDelegate = self
        
        setUI()
        postModel.loadPost(from: postType)
    }
    
    func setUI() {
        self.navigationItem.title = "게시판(학생회공지)"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        postTableView.tableHeaderView = searchController.searchBar
        
    }
    
    @IBAction func writeTouched(_ sender: Any) {
        self.performSegue(withIdentifier: "WritePostSegue", sender: nil)
    }
    
    @IBAction func postSegmentChanged(_ sender: Any) {
        
        self.navigationItem.title = "게시판(\(postSegment.titleForSegment(at: postSegment.selectedSegmentIndex) ?? ""))"
        
        switch postSegment.selectedSegmentIndex {
        case 0:
            postType = "student_notice"
            break;
        case 1:
            postType = "reviews"
            break;
        case 2:
            postType = "markets"
            break;
        case 3:
            postType = "questions"
            break;
        default:
            break;
        }
        postModel.loadPost(from: postType)
    }
    
    func didChange(_ posts: [Post]) {
        self.posts = posts
        self.postTableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailPostSegue" {
            let detailVC = (segue.destination as! DetailPostNavigationController).viewControllers.first as! DetailPostViewController
            var post: Post
            if searchController.isActive && searchController.searchBar.text != "" {
                post = filterPosts[(postTableView.indexPathForSelectedRow)!.row]
            }
            else {
                post = posts[(postTableView.indexPathForSelectedRow)!.row]
            }
            detailVC.post = post
            detailVC.postType = self.postType
        }
        else if segue.identifier == "WritePostSegue" {
            let writeVC = (segue.destination as! WritePostNavigationController).viewControllers.first as! WritePostViewController
            writeVC.postType = self.postType
        }
        else if segue.identifier == "EditPostSegue" {
            let editVC = (segue.destination as! WritePostNavigationController).viewControllers.first as! WritePostViewController
            editVC.postType = self.postType
            editVC.post = sender as? Post
        }
    }
}

extension PostViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if posts[indexPath.row].authorUid == UserDefaults.standard.object(forKey: "uid") as? String {
            var post: Post
            if searchController.isActive && searchController.searchBar.text != "" {
                post = filterPosts[indexPath.row]
            }
            else {
                post = posts[indexPath.row]
            }
            
            let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { (action, index) in
                self.postModel.remove(self.postType, (post.key)!)
            }
            let editAction = UITableViewRowAction(style: .normal, title: "수정") { (action, index) in
                self.performSegue(withIdentifier: "EditPostSegue", sender: post)
            }
            
            return [deleteAction, editAction]
        }
        return []
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterPosts.count
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        var post: Post
        if searchController.isActive && searchController.searchBar.text != "" {
            post = filterPosts[indexPath.row]
        }
        else {
            post = posts[indexPath.row]
        }
        
        cell.titleLabel.text = post.title! + " (\(post.commentCount!))"
        cell.subtitleLabel.text = "\(post.author!)\t\(post.timestamp!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PostViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterPostForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterPostForSearchText(searchText: String) {
        self.filterPosts = posts.filter({ (post) -> Bool in
            return (post.title?.contains(searchText))!
        })
        postTableView.reloadData()
    }
}
