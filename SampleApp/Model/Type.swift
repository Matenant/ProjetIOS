//
//  Type.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

class Type {
    let Title: String
    let Nombre: Int
    let Image: String
    
    let Tasks: [Task]
    
    init(Title: String, Image: String, Tasks: [Task]){
        self.Title = Title
        self.Nombre = Tasks.count
        self.Tasks = Tasks
        self.Image = Image
    }
}
