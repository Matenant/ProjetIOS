//
//  todoCellViewControler.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit

class TodoCellViewController: UITableViewCell {
    
    var cellID: Int!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var check: UISwitch!
    
    
    @IBAction func changeCheck(_ sender: Any) {
        
    }
}
