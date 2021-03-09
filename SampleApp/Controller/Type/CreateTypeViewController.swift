//
//  CreateTypeViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire

class CreateTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var userID: Int?
    
    var icon: String?
    var strName: String?
    var catID: Int?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tabIcon: UITableView!
    
    let identifier = "IconCustom"
    
    var iconData: [String] = []
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewDidLoad() {
        
        
        SFSymbol.allCases.forEach {
            iconData.append($0.rawValue)
        }
        
        tabIcon.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        //self.tableView.selectRow(at: , animated: false, scrollPosition: UITableViewScrollPosition.none)
        
        if let safeName = strName {
            name.text = safeName
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabIcon.delegate = self
        tabIcon.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: IconCellViewController! = tabIcon.dequeueReusableCell(withIdentifier: identifier) as? IconCellViewController
        
        cell.icon.image = UIImage(systemName: iconData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        icon = iconData[indexPath.row]
    }
    
    @IBAction func ajouter(_ sender: Any) {
        
        if let safeName = name.text, let safeIcon = icon, let safeUserID = userID  {
            if let safeCatID = catID {
                let type = structType(name: safeName, icon: safeIcon, user_id: safeUserID)
                AF.request("http://51.210.110.120:8000/api/categories/\(safeCatID)", method: .put, parameters: type, encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success:
                        self.dismiss(animated: true, completion: nil)
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            else {
                let type = structType(name: safeName, icon: safeIcon, user_id: safeUserID)
                AF.request("http://51.210.110.120:8000/api/categories", method: .post, parameters: type, encoder: JSONParameterEncoder.default).response { response in
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
    
}

