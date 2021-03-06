//
//  CreateTypeViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit
import Alamofire

class CreateTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var icon: String?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tabIcon: UITableView!
    
    let identifier = "IconCustom"
    
    var iconData: [String] = []
    
    override func viewDidLoad() {
        
        SFSymbol.allCases.forEach {
            iconData.append($0.rawValue)
        }
        
        tabIcon.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: identifier)
        
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
        let user_id: Int = 1
        if let safeName = name.text, let safeIcon = icon  {
            let type = structType(name: safeName, icon: safeIcon, user_id: user_id)
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
