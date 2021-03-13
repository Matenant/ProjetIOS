//
//  todoCellViewControler.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire

//class qui controle la vue d'une tâche
class TodoCellViewController: UITableViewCell {
    
    var cellID: Int?
    var typeID: Int?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UISwitch!
    
    //quand on change le bouton check, ça envoie une requête avec le changement
    @IBAction func changeCheck(_ sender: Any) {
        //On vérifie que les infos de la tâche sont toujours bonne et on envoie la modification
        if let safeCellID = cellID, let safeTypeID = typeID, let safeName = name.text {
            let task = structTask(name: safeName, checked: check.isOn, categorie_id: safeTypeID)
            AF.request("http://51.210.110.120:8000/api/todos/\(safeCellID)", method: .put, parameters: task, encoder: JSONParameterEncoder.default).response {
                response in
                print(response)
            }
        }
        
        
    }
}
