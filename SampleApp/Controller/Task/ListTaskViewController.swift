//
//  ListViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

//affichage des tâches
class ListTaskViewController: UITableViewController{
    
    //ID de la catégorie
    var typeID: Int?
    
    var listTask: [Task] = []
    
    let identifier = "TaskCustom"
    
    override func viewDidLoad() {
        //on recupère la cellule custom
        tableView.register(UINib(nibName: "CheckCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        super.viewDidLoad()
        
    }
    
    //récupération dans le willAppear pour rafraichir la vue
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //on vide le tableau sinon doublon
        listTask = []
        self.tableView.reloadData()
        
        //si on a une catégorie alors on récupère les éléments
        if let typeIdSafe = typeID {
            
            AF.request("http://51.210.110.120:8000/api/categories/\(typeIdSafe)").response { response in
                
                do {
                    if let dataSafe = response.data {
                        let json = try JSON(data: dataSafe)
                        //on récupère les tâches par rapport à une catégorie
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
    
    //création de la cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //on crée la cellule du type de la cellule custom
        let cell: TodoCellViewController! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TodoCellViewController
        
        cell.typeID = typeID
        cell.cellID = listTask[indexPath.row].ID
        cell.name.text = listTask[indexPath.row].Name
        cell.check.setOn(listTask[indexPath.row].Check, animated: true)
        
        return cell
    }
    
    //swipe sur une cellule pour afficher supprimer et modifier
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Supprimer",handler: {
            (action, view, completion) in
            completion(true)
            //quand on clique on va dans la fonction remove
            self.remove(ligne: indexPath.row)
        })
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .destructive, title: "Modifier", handler: { (action, view, completion) in
            completion(true)
            //quand on clique on va sur l'écran CreateTask pour modifier
            self.performSegue(withIdentifier: "segueToModifyTask", sender: indexPath.row)
        })
        edit.backgroundColor = .green
        
        //ajoute la configuration à la table view
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    //function pour supprimer un élément quand on clique sur delete
    func remove(ligne: Int){
        AF.request("http://51.210.110.120:8000/api/todos/\(listTask[ligne].ID)", method: .delete).response { response in
            switch response.result {
            case let .failure(error):
                print(error)
            case .success(_):
                //si on réussi à supprimer on peut enlever l'élément dans le tableau
                self.listTask.remove(at: ligne)
                //et recharger la table view
                self.tableView.reloadData()
            }
        }
    }
    
    //quand on clique sur le bouton ajouter en haut à droite
    @IBAction func ajoutTache(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToCreateTask", sender: typeID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
        switch segue.identifier {
        //quand on créer on passe par ce segue
        case "segueToCreateTask":
            let typeID = sender as? Int
            
            if let viewControllerDestination = segue.destination as? CreateTaskViewController {
                viewControllerDestination.typeID = typeID
            }
        //quand on modifie on passe par ce segue
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

