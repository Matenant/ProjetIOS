//
//  structure.swift
//  SampleApp
//
//  Created by Matheo Faivre on 06/03/2021.
//

//permet de passer une tache à la requête http
struct structTask: Encodable {
    let name: String
    let checked: Bool
    let categorie_id: Int
}

//permet de passer une catégorie à la requête http
struct structType: Encodable {
    let name: String
    let icon: String
    let user_id: Int
}

//permet de passer les login à la requête http
struct structLogin: Encodable{
    let email: String
    let password: String
}

//permet de passer l'enregistrement à la requête http
struct structRegister: Encodable {
    let name: String
    let email: String
    let password: String
}
