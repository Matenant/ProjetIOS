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
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTask = []
        self.tableView.reloadData()
        
        
        if let typeIdSafe = typeID {
            
            AF.request("http://51.210.110.120:8000/api/categories/\(typeIdSafe)").response { response in
                
                do {
                    if let dataSafe = response.data {
                        let json = try JSON(data: dataSafe)
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
        
        cell.typeID = typeID
        cell.cellID = listTask[indexPath.row].ID
        cell.name.text = listTask[indexPath.row].Name
        cell.check.setOn(listTask[indexPath.row].Check, animated: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            boolValue(true)
        }
        delete.backgroundColor = .red
        let edit = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
            boolValue(true)
        }
        edit.backgroundColor = .green
        let swipeActions = UISwipeActionsConfiguration(actions: [edit])

        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Supprimer",handler: {
            (action, view, completion) in
            completion(true)
            self.remove(ligne: indexPath.row)
        })
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .destructive, title: "Modifier", handler: { (action, view, completion) in
            completion(true)
            self.performSegue(withIdentifier: "segueToModifyTask", sender: indexPath.row)
        })
        edit.backgroundColor = .green
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func remove(ligne: Int){
        AF.request("http://51.210.110.120:8000/api/todos/\(listTask[ligne].ID)", method: .delete).response { response in
            switch response.result {
            case let .failure(error):
                print(error)
            case .success(_):
                self.listTask.remove(at: ligne)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func ajoutTache(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToCreateTask", sender: typeID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
        switch segue.identifier {
        case "segueToCreateTask":
            let typeID = sender as? Int
            
            if let viewControllerDestination = segue.destination as? CreateTaskViewController {
                viewControllerDestination.typeID = typeID
            }
        case "segueToModifyTask":
            if let ligne = sender as? Int, let viewControllerDestination = segue.destination as? CreateTaskViewController {
                viewControllerDestination.strName = listTask[ligne].Name
                viewControllerDestination.typeID = typeID
                viewControllerDestination.ID = listTask[ligne].ID
            }
        default:
            print("")
        }
            
    }
}

