//
//  structure.swift
//  SampleApp
//
//  Created by Matheo Faivre on 06/03/2021.
//

struct structTask: Encodable {
    let name: String
    let checked: Bool
    let categorie_id: Int
}

struct structType: Encodable {
    let name: String
    let icon: String
    let user_id: Int
}

struct structLogin: Encodable{
    let email: String
    let password: String
}

struct structRegister: Encodable {
    let name: String
    let email: String
    let password: String
}
