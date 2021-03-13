//
//  ListTypeViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

//Permet de lister les catégories
class ListTypeViewController: UITableViewController{
    
    var userID: Int?
    
    var listType: [Type] = []
    
    let identifier = "TypeCustom"
    
    override func viewDidLoad() {
        
        //renseigne la cellule custom
        tableView.register(UINib(nibName: "TypeCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        super.viewDidLoad()
        
    }
    
    //on fait l'affichage dans le willAppear pour pouvoir recharger
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listType = []
        self.tableView.reloadData()
        
        //si on a bien un utilisateur on fait la récupération
        if let typeIdSafe = userID {
            
            AF.request("http://51.210.110.120:8000/api/users/\(typeIdSafe)/categories").response { response in
                
                do {
                    if let dataSafe = response.data {
                        let json = try JSON(data: dataSafe)
                        //On ajoute dans la table listType toutes les catégories en fonction de l'ID utilisateur
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
    
    //On parcourt les catégories et on les affiches
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //on crée la cellule du type de la cellule custom
        let cell: TypeCellViewController! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TypeCellViewController
        
        cell.title.text = listType[indexPath.row].Title
        cell.icon.image = UIImage(systemName: listType[indexPath.row].Image)
        
        
        return cell
    }
    
    //on fait le slider de cellule avec supprimer et modifier
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Supprimer",handler: {
            (action, view, completion) in
            completion(true)
            //on va dans remove pour supprimer la ligne (Dans l'api ça supprime les enfants aussi
            self.remove(ligne: indexPath.row)
        })
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .destructive, title: "Modifier", handler: { (action, view, completion) in
            completion(true)
            //on va dans l'écran de création/modification pour changer la catégorie
            self.performSegue(withIdentifier: "segueToModifyType", sender: indexPath.row)
        })
        edit.backgroundColor = .green
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    //quand on veut supprimer on arrive ici
    func remove(ligne: Int){
        AF.request("http://51.210.110.120:8000/api/categories/\(listType[ligne].ID)", method: .delete).response { response in
            switch response.result {
            case let .failure(error):
                print(error)
            case .success(_):
                //si on réussi on va supprimer la ligne dans le tableau
                self.listType.remove(at: ligne)
                //et on recharge le table view
                self.tableView.reloadData()
            }
        }
    }
    
    //Si on clique sur le bouton ajouter on va dans lécran de création
    @IBAction func ajouter(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToAddType", sender: nil)
    }
    
    //si on clique sur une ligne on va dans l'écran de liste des tâches en passant l'id de la catégorie
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueToTaskDescription", sender: listType[indexPath.row].ID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    //Le segue pour passer dans les différentes vues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch segue.identifier {
        //si on ajoute une catégorie on va dans le createTypeViewController avec l'id utilisateur
        case "segueToAddType":
            if let viewControllerDestination = segue.destination as? CreateTypeViewController {
                viewControllerDestination.userID = userID
            }
        //Si on clique sur une catégorie ça nous affiche la liste des tâches de la catégorie
        case "segueToTaskDescription":
            if let typeID = sender as? Int, let viewControllerDestination = segue.destination as? ListTaskViewController {
                viewControllerDestination.typeID = typeID
            }
        //Si on slide et qu'on clique sur modifier on va dans le createTypeViewController avec les infos de la catégorie
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
