//
//  CreateTypeViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire

//permet de créer ou modifier une catégorie
class CreateTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //utilisateur ID pour pouvoir ajouter dans un utilisateur
    var userID: Int?
    
    //variable si on modifie une catégorie
    var icon: String?
    var strName: String?
    var catID: Int?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tabIcon: UITableView!
    
    let identifier = "IconCustom"
    
    //tableau de icone
    var iconData: [String] = []
    
    
    override func viewDidLoad() {
        //on ajoute les symboles de l'énumération dans un tableau pour les affichers après
        SFSymbol.allCases.forEach {
            iconData.append($0.rawValue)
        }
        
        //on récupère la cellule custom
        tabIcon.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        //si on a un nom on l'ajoute dans la saisie de texte
        if let safeName = strName {
            name.text = safeName
        }
        
        super.viewDidLoad()
        
        tabIcon.delegate = self
        tabIcon.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //on ajoute les éléments dans
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //on crée la cellule du type de la cellule custom
        let cell: IconCellViewController! = tabIcon.dequeueReusableCell(withIdentifier: identifier) as? IconCellViewController
        
        cell.icon.image = UIImage(systemName: iconData[indexPath.row])
        
        return cell
    }
    
    //on récupère le nom de la ligne sélectionné
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        icon = iconData[indexPath.row]
    }
    
    //Quand on ajoute
    @IBAction func ajouter(_ sender: Any) {
        //On vérifie qu'on a tous les éléments
        if let safeName = name.text, let safeIcon = icon, let safeUserID = userID  {
            //Si on a une catégorie d'ID on doit modifier
            if let safeCatID = catID {
                let type = structType(name: safeName, icon: safeIcon, user_id: safeUserID)
                AF.request("http://51.210.110.120:8000/api/categories/\(safeCatID)", method: .put, parameters: type, encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            //sinon on ajoute dans la base
            else {
                let type = structType(name: safeName, icon: safeIcon, user_id: safeUserID)
                AF.request("http://51.210.110.120:8000/api/categories", method: .post, parameters: type, encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            
        }
        
        
    }
    
}

