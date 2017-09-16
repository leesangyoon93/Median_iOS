//
//  MainViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MainViewController: UIViewController, NoticeChangeDelegate {
    
    @IBOutlet weak var noticeTableView: UITableView!
    
    var notices = [Notice]()
    var filterNotices = [Notice]()
    let noticeModel = NoticeModel()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noticeModel.noticeChangeDelegate = self
        noticeModel.loadNotice()
        
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        
        setUI()
        
    }
    
    func setUI() {
        self.navigationItem.title = "NOTICE"
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        noticeTableView.tableHeaderView = searchController.searchBar
    }
    
    func didChange(_ notices: [Notice]) {
        self.notices = notices
        self.noticeTableView.reloadData()
    }
    
    // Logout
//    func showLogoutDialog(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        let logoutAction = UIAlertAction(title: "확인", style: .default) { (_) in
//            do {
//                try
//                    FIRAuth.auth()!.signOut()
//                    GIDSignIn.sharedInstance().signOut()
//                
//                let appDomain = Bundle.main.bundleIdentifier
//                UserDefaults.standard.removePersistentDomain(forName: appDomain!)
//                
//                let indexVC = self.storyboard?.instantiateViewController(withIdentifier: "IndexViewController") as! IndexViewController
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = indexVC
//                
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//            }
//            
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(logoutAction)
//        
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailNoticeSegue" {
            let detailNoticeVC = (segue.destination as! NoticeNavigationController).viewControllers.first as! DetailNoticeViewController
            var notice: Notice
            if searchController.isActive && searchController.searchBar.text != "" {
                notice = filterNotices[(self.noticeTableView.indexPathForSelectedRow)!.row]
            }
            else {
                notice = notices[(self.noticeTableView.indexPathForSelectedRow)!.row]
            }
            detailNoticeVC.notice = notice
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterNotices.count
        }
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.noticeTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeTableViewCell
        
        var notice: Notice
        if searchController.isActive && searchController.searchBar.text != "" {
            notice = filterNotices[indexPath.row]
        }
        else {
            notice = notices[indexPath.row]
        }
        cell.titleLabel.text = notice.title!
        
        return cell
    }

}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterNoticeForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterNoticeForSearchText(searchText: String) {
        self.filterNotices = notices.filter({ (notice) -> Bool in
            return (notice.title?.contains(searchText))!
        })
        noticeTableView.reloadData()
    }
}
