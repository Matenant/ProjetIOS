//
//  CreateTypeViewController.swift
//  SampleApp
//
//  Created by Matheo Faivre on 05/03/2021.
//

import UIKit

class CreateTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
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
    
    @IBAction func ajouter(_ sender: Any) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: IconCellViewController! = tabIcon.dequeueReusableCell(withIdentifier: identifier) as? IconCellViewController
        
        cell.icon = UIImageView(image: UIImage(systemName: iconData[indexPath.row]))

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(iconData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
