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
    @IBOutlet weak var name: UITextField!
    
    @IBAction func ajouter(_ sender: Any) {
        
        if let safeTypeID = typeID, let safeName = name.text {
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
