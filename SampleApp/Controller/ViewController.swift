//
//  ViewController.swift
//  SampleApp
//
//  Created by jficerai on 04/03/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var identifiant: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    struct structLogin: Encodable{
        let email: String
        let password: String
    }

    @IBAction func connection(_ sender: Any) {
        if let safeEmail = identifiant.text, let safePassword = mdp.text {
            let login = structLogin(email: safeEmail, password: safePassword)
            AF.request("http://51.210.110.120:8000/api/login", method: .get, parameters: login, encoder: JSONParameterEncoder.default).response { response in
                switch response.result {
                case .success:
                    print("ok")
                case let .failure(error):
                    print(error)
                }
                
            }
        }
    }
    //perform segue
    
    //prepare segue
    
}

