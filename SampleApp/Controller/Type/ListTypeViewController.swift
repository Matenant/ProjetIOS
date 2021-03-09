//
//  ListTypeViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListTypeViewController: UITableViewController{
    
    //var testTask: [Task] = [Task(Name: "Tâche 1", Check: true),
    //                        Task(Name: "Tâche 2", Check: false)]
    
    var userID: Int?
    
    var listType: [Type] = []
    
    let identifier = "TypeCustom"
    
    override func viewDidLoad() {
        
        //listType = [Type(Title: "Travail", Image: "a", Tasks: testTask),
        //Type(Title: "Maison", Image: "trash", Tasks: testTask),
        //Type(Title: "Voiture", Image: "trash", Tasks: testTask)]
        
        tableView.register(UINib(nibName: "TypeCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listType = []
        self.tableView.reloadData()
        
        if let typeIdSafe = userID {
            
            AF.request("http://51.210.110.120:8000/api/users/\(typeIdSafe)/categories").response { response in
                
                do {
                    if let dataSafe = response.data {
                        let json = try JSON(data: dataSafe)
                        for type in json.arrayValue {
                            self.listType.append(Type(ID: type["id"].intValue, Title: type["name"].stringValue, Image: type["icon"].stringValue, UserID: type["user_id"].intValue))
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
        return "Liste des catégories"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TypeCellViewController! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TypeCellViewController
        
        cell.title.text = listType[indexPath.row].Title
        //cell.nombre.text = "\(listType[indexPath.row].Nombre) tâche(s)"
        cell.icon.image = UIImage(systemName: listType[indexPath.row].Image)
        
        
        return cell
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
            self.performSegue(withIdentifier: "segueToModifyType", sender: indexPath.row)
        })
        edit.backgroundColor = .green
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func remove(ligne: Int){
        AF.request("http://51.210.110.120:8000/api/categories/\(listType[ligne].ID)", method: .delete).response { response in
            switch response.result {
            case let .failure(error):
                print(error)
            case .success(_):
                self.listType.remove(at: ligne)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func ajouter(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToAddType", sender: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToTaskDescription", sender: listType[indexPath.row].ID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch segue.identifier {
        case "segueToAddType":
            if let viewControllerDestination = segue.destination as? CreateTypeViewController {
                viewControllerDestination.userID = userID
            }
        case "segueToTaskDescription":
            if let typeID = sender as? Int, let viewControllerDestination = segue.destination as? ListTaskViewController {
                viewControllerDestination.typeID = typeID
            }
        case "segueToModifyType":
            if let ligne = sender as? Int, let viewControllerDestination = segue.destination as? CreateTypeViewController {
                viewControllerDestination.strName = listType[ligne].Title
                viewControllerDestination.icon = listType[ligne].Image
                viewControllerDestination.userID = listType[ligne].UserID
                viewControllerDestination.catID = listType[ligne].ID
            }
        default:
            print("")
        }
    }
}
