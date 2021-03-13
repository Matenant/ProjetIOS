//
//  Type.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

//class qui décrit une catégorie (un type de tâche)
class Type {
    let ID: Int
    let Title: String
    let Image: String
    let UserID: Int
    
    init(ID: Int, Title: String, Image: String, UserID: Int){
        self.ID = ID
        self.Title = Title
        self.Image = Image
        self.UserID = UserID
    }
}
