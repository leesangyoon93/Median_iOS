//
//  InfoTableViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController, InfoLoadDelegate {

    let infoModel = InfoModel()
    var infos = [Information]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoModel.infoLoadDelegate = self
        setUI()
        infoModel.loadInfo()
    }
    
    func setUI() {
        self.navigationItem.title = "정보"
        
    }
    
    func didLoad(_ infos: [Information]) {
        self.infos = infos
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.infos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell
        
        if infos.count > 0 {
            print(infos[indexPath.row].profileImage!)
            cell.infoImgView.image = UIImage(named: infos[indexPath.row].profileImage!)
            cell.emailLabel.text = infos[indexPath.row].email!
            cell.nameLabel.text = infos[indexPath.row].name!
            cell.telLabel.text = "\(infos[indexPath.row].tel!)"
            cell.officeLabel.text = infos[indexPath.row].office!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let callAction = UITableViewRowAction(style: .normal, title: "Call") { (action, index) in
            guard let number = URL(string: "tel://031-219" + "\(self.infos[indexPath.row].tel!)") else { return }
            UIApplication.shared.open(number)
        }
        return [callAction]
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
