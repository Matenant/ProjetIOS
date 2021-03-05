//
//  ListViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListTaskViewController: UITableViewController{
    
    var type: Type? = nil
    
    var listTask: [Task] = []
    
    let identifier = "TaskCustom"
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "CheckCell", bundle: nil), forCellReuseIdentifier: identifier)
        listTask = type?.Tasks ?? [Task(Name: "Pas de tâche", Check: false)]
        
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Liste des tâches"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTask.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        var cell: TodoCellViewController! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TodoCellViewController
        
        cell.name.text = listTask[indexPath.row].Name
        cell.check.setOn(listTask[indexPath.row].Check, animated: true)
        
        return cell
    }
}

