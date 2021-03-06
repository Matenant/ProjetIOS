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
    
    var listType: [Type] = []
    
    let identifier = "TypeCustom"
    
    override func viewDidLoad() {
        
        //listType = [Type(Title: "Travail", Image: "a", Tasks: testTask),
                    //Type(Title: "Maison", Image: "trash", Tasks: testTask),
                    //Type(Title: "Voiture", Image: "trash", Tasks: testTask)]
        
        tableView.register(UINib(nibName: "TypeCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        AF.request("http://51.210.110.120:8000/api/categories").response { response in

            do {
                if let dataSafe = response.data {
                    let json = try JSON(data: dataSafe)
                    for type in json.arrayValue {
                        self.listType.append(Type(ID: type["id"].intValue, Title: type["name"].stringValue, Image: type["icon"].stringValue))
                    }
                    self.tableView.reloadData()
                }
            } catch {
                print("err")
            }
        }
        
        super.viewDidLoad()
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToTaskDescription", sender: listType[indexPath.row].ID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let typeID = sender as? Int
        
        if let viewControllerDestination = segue.destination as? ListTaskViewController {
            viewControllerDestination.typeID = typeID
        }
    }
}


