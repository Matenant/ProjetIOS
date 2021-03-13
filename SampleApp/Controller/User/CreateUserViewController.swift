//
//  CreateUserViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 09/03/2021.
//

import UIKit
import Alamofire

//class permettant de créer un utilisateur
class CreateUserViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var mdp: UITextField!
    
    //quand on clique sur le bouton ça envoie la structure Register en requête http
    @IBAction func enregistrer(_ sender: Any) {
        //on vérifie que tous les champs sont saisies
        if let safeName = name.text, let safeEMail = eMail.text, let safeMDP = mdp.text {
            let user = structRegister(name: safeName, email: safeEMail, password: safeMDP)
            AF.request("http://51.210.110.120:8000/api/register", method: .post, parameters: user, encoder: JSONParameterEncoder.default).response { response in
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
