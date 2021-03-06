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
    
    var typeID: Int?
    
    var listTask: [Task] = []
    
    let identifier = "TaskCustom"
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "CheckCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        //listTask = type?.Tasks ?? [Task(Name: "Pas de tâche", Check: false)]
        if let typeIdSafe = typeID {
            
            AF.request("http://51.210.110.120:8000/api/categories/\(typeIdSafe)").response { response in
                
                do {
                    if let dataSafe = response.data {
                        let json = try JSON(data: dataSafe)
                        print(json.arrayValue)
                        print(json.arrayValue[0]["todos"])
                        for task in json.arrayValue[0]["todos"].arrayValue {
                            self.listTask.append(Task(ID: task["id"].intValue, Name: task["name"].stringValue, Check: task["checked"].boolValue))
                        }
                        self.tableView.reloadData()
                    }
                } catch {
                    print("err")
                }
            }
        }
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
        
        
        
        let cell: TodoCellViewController! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TodoCellViewController
        
        cell.cellID = listTask[indexPath.row].ID
        cell.name.text = listTask[indexPath.row].Name
        cell.check.setOn(listTask[indexPath.row].Check, animated: true)
        
        return cell
    }
}

