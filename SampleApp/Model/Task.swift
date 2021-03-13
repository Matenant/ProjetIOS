//
//  Task.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

// Class qui décrit une tâche
class Task {
    let ID: Int
    let Name: String
    let Check: Bool
    
    init(ID: Int, Name: String, Check: Bool){
        self.ID = ID
        self.Name = Name
        self.Check = Check
    }
}
