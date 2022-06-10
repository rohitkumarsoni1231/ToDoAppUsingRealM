//
//  ViewController.swift
//  TodoAppUsingRealM
//
//  Created by MacBook on 08/06/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    
    var contactArray = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    //MARK: - addContactBtnTapped(_ sender: UIBarButtonItem)
    @IBAction func addContactBtnTapped(_ sender: UIBarButtonItem) {
        contactConfiguration(isAdd: true, index: 0)
    }
}

extension ViewController {
    func configuration() {
        contactTableView.delegate = self
        contactTableView.dataSource = self
        contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contactArray = DatabaseHelper.shared.getAllContacts()
    }
    
    func contactConfiguration(isAdd: Bool, index: Int) {
        
        let alertController = UIAlertController(title: isAdd ? "Add Contact" : "Update Contact" , message: isAdd ? "Please enter your contact details" : "Please update contact details", preferredStyle: .alert)
        let save = UIAlertAction(title: isAdd ? "Save" : "Update", style: .default) { _ in
            if let firstName = alertController.textFields?.first?.text,
               let lastName = alertController.textFields?[1].text {
                print(firstName, lastName)
                let contact = Contact(firstName: firstName, lastName: lastName)
                
                if isAdd {
                    self.contactArray.append(contact)
                    DatabaseHelper.shared.saveContact(contact: contact)
                } else {
                    //self.contactArray[index] = contact
                    DatabaseHelper.shared.updateContact(oldContact: self.contactArray[index], newContact: contact)
                }
                self.contactTableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { firstNameField in
            firstNameField.placeholder = isAdd ? "Enter Your First Name" : self.contactArray[index].firstName
        }
        
        alertController.addTextField { lastNameField in
            lastNameField.placeholder = isAdd ? "Enter Your Last Name" : self.contactArray[index].lastName
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
           return UITableViewCell()
        }
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = contactArray[indexPath.row].firstName
        cell.detailTextLabel?.text = contactArray[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.contactConfiguration(isAdd: false, index: indexPath.row)
        }
        
        edit.backgroundColor = .systemMint
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            print(self.contactArray[indexPath.row])
            DatabaseHelper.shared.deleteContact(contact: self.contactArray[indexPath.row])
            self.contactArray.remove(at: indexPath.row)
            self.contactTableView.reloadData()
        }
        
        let swipeConfirguration = UISwipeActionsConfiguration(actions: [edit,delete])
        return swipeConfirguration
    }
    
}

