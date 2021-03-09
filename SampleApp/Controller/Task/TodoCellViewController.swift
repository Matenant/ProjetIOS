//
//  todoCellViewControler.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire

class TodoCellViewController: UITableViewCell {
    
    var cellID: Int?
    var typeID: Int?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UISwitch!
    
    
    @IBAction func changeCheck(_ sender: Any) {
        if let safeCellID = cellID, let safeTypeID = typeID, let safeName = name.text {
            let task = structTask(name: safeName, checked: check.isOn, categorie_id: safeTypeID)
            AF.request("http://51.210.110.120:8000/api/todos/\(safeCellID)", method: .put, parameters: task, encoder: JSONParameterEncoder.default).response {
                response in
                print(response)
            }
        }
        
        
    }
}
