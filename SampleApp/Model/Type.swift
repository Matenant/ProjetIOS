//
//  Type.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

class Type {
    let Title: String
    let Nombre: Int
    
    let Tasks: [Task]
    
    init(Title: String, Tasks: [Task]){
        self.Title = Title
        self.Nombre = Tasks.count
        self.Tasks = Tasks
    }
}
