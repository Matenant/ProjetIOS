//
//  CreateTaskViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 06/03/2021.
//

import UIKit
import Alamofire

class CreateTaskViewController: UIViewController {
    var typeID: Int?
    var strName: String?
    var ID: Int?
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        if let safeName = strName {
            name.text = safeName
        }
    }
    
    @IBAction func ajouter(_ sender: Any) {
        
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
