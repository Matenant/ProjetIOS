//
//  CreateTaskViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 06/03/2021.
//

import UIKit
import Alamofire

//Controle de la vue de création et de modification d'une tâche
class CreateTaskViewController: UIViewController {
    //paramètre venant de l'ancienne vue pour la modification
    var typeID: Int?
    var strName: String?
    var ID: Int?
    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        //si la paramètre nom n'est pas null
        if let safeName = strName {
            name.text = safeName
        }
    }
    
    //quand on appuie sur ajouter
    @IBAction func ajouter(_ sender: Any) {
        //si il y a un id alors c'est une modification
        if let safeTypeID = typeID, let safeName = name.text {
            if let safeID = ID {
                let task = structTask(name: safeName, checked: false, categorie_id: safeTypeID)
                AF.request("http://51.210.110.120:8000/api/todos/\(safeID)", method: .put, parameters: task, encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            //sinon on ajoute
            else{
                let task = structTask(name: safeName, checked: false, categorie_id: safeTypeID)
                AF.request("http://51.210.110.120:8000/api/todos", method: .post, parameters: task, encoder: JSONParameterEncoder.default).response { response in
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
