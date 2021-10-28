//
//  ViewController.swift
//  FaceTime Clone App
//
//  Created by Andrea Gualandris on 27/10/2021.
//

import UIKit

class ContactsViewController: UIViewController {
    
    
    lazy var contactsModel : [String] = ["Lily-Ann Bowden",
                                         "Monique Healy",
                                         "Dominik Bassett",
                                         "Imani Bright",
                                         "Lily-May Devine",
                                         "Oluwatobiloba Corona",
                                         "Miriam Phelps",
                                         "Ishaq Fitzgerald",
                                         "Andreas Beck",
                                         "Ismael Castaneda",
                                         "Zakariah Boyle",
                                         "Samah Martinez",
                                         "Gaia Figueroa",
                                         "Liyah Davison",
                                         "Saanvi Payne",
                                         "Menna Millington",
                                         "Mackenzie Whyte",
                                         "Joel Cervantes",
                                         "Arnold Hart"]
    
    lazy var tableView : UITableView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        navigationItem.title = "Your Contacts"
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
    }


}

@available(iOS 13.0, *)
extension ContactsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
        cell.textLabel?.text = contactsModel[indexPath.item]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
        //present call chiamata
        let callVC = CallController()
        callVC.modalTransitionStyle = .crossDissolve
        callVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(callVC, animated: true)
    }
    
}

