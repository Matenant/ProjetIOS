//
//  ViewController.swift
//  SampleApp
//
//  Created by jficerai on 04/03/2021.
//
// Projet de Naiby Aguilar, Siri Romaric, Faivre Mathéo

import UIKit
import Alamofire
import SwiftyJSON

//token pour la connexion (pas utilisé ici)
var token: String = ""

//première vue
class ViewController: UIViewController {

    @IBOutlet weak var identifiant: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    //connexion à la plateforme
    @IBAction func connection(_ sender: Any) {
        if let safeEmail = identifiant.text, let safePassword = mdp.text {
            let login = structLogin(email: safeEmail, password: safePassword)
            AF.request("http://51.210.110.120:8000/api/login", method: .post, parameters: login, encoder: JSONParameterEncoder.default).response { response in
                switch response.result {
                    //si ça réussi alors on passe à la suite grâce au performSegue avec l'id utilisateur
                case .success:
                    do {
                        if let dataSafe = response.data {
                            let json = try JSON(data: dataSafe)
                            //on récupère les infos de l'api sur l'utilisateur
                            token = json["access_token"].stringValue
                            if json["user"]["id"].intValue != 0 {
                                self.performSegue(withIdentifier: "segueToTypeList", sender: json["user"]["id"].intValue)
                            }
                        }
                    } catch {
                        print("err")
                    }
                    
                case let .failure(error):
                    print(error)
                }
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let userID = sender as? Int
        
        if let viewControllerDestination = segue.destination as? ListTypeViewController {
            viewControllerDestination.userID = userID
        }
    }
    
}

