//
//  FavoriteContactsViewController.swift
//  Watchill
//
//  Created by Laricia Mota on 10/05/19.
//  Copyright :copyright: 2019 Laricia Mota. All rights reserved.
//

import UIKit
import ContactsUI


class FavoriteContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    let favorite = Defaults.shared
    let SAVE = "Salvar"
    let EDIT = "Editar"
    let ADD = "\u{002B}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.delegate = self
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editing))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(adding))
        
        navigationItem.rightBarButtonItems = [addButton, editButton]
        
        favoritesTableView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.87, alpha:1.0)
        favoritesTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        disableEditing()
    }
    
    func disableEditing(){
        favoritesTableView.setEditing(false, animated: true)
        navigationItem.leftBarButtonItem?.title = EDIT
    }
    
    @objc private func adding() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        UINavigationBar.appearance().tintColor = UIColor(red:0.15, green:0.42, blue:0.45, alpha:1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0.15, green:0.42, blue:0.45, alpha:1.0)]
        
        UITableView.appearance().tintColor = UIColor(red:0.15, green:0.42, blue:0.45, alpha:1.0)
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let favContact = Contact(name: contact.givenName + " " + contact.familyName, phone: contact.phoneNumbers.first?.value.stringValue ?? "")
        addFavorite(favorite: favContact)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc private func editing() {
        favoritesTableView.setEditing(!favoritesTableView.isEditing, animated: true) // Set opposite value of current editing status
        navigationItem.leftBarButtonItem?.title = favoritesTableView.isEditing ? SAVE : EDIT // Set title depending on the editing status
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = self.favorite.contacts[sourceIndexPath.row]
        self.favorite.contacts.remove(at: sourceIndexPath.row)
        self.favorite.contacts.insert(rowToMove, at: destinationIndexPath.row)
        self.favoritesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorite.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
            let person = self.favorite.contacts[indexPath.row]
            
            cell.nameLabel.text = person.name
            cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cell.phoneLabel.text = person.phone
            
            cell.backgroundColor = UIColor.clear

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherFavoritesTableViewCell") as! OtherFavoritesTableViewCell
            let person = self.favorite.contacts[indexPath.row]
            
            cell.nameLabel.text = person.name
            cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cell.phoneLabel.text = person.phone
            
            cell.backgroundColor = UIColor.clear

            return cell
        }
    }
    
    func addFavorite(favorite: Contact){
        if(!self.favorite.contacts.contains(where: { (contact) -> Bool in
            (contact.name == favorite.name) && (contact.phone == favorite.phone)
        })){
            let newIndexPath = IndexPath(row: self.favorite.contacts.count, section: 0)
            self.favorite.contacts.append(favorite)
            self.favoritesTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.favorite.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.favoritesTableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if tableView.isEditing {
            if let cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell {
                cell.callButton.isHidden = true
            } else if let cell = tableView.cellForRow(at: indexPath) as? OtherFavoritesTableViewCell {
                cell.callButton.isHidden = true
            }
            
            return true
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? FavoriteTableViewCell {
            cell.callButton.isHidden = false
        } else if let cell = tableView.cellForRow(at: indexPath) as? OtherFavoritesTableViewCell {
            cell.callButton.isHidden = false
        }
        
        return false
    }
    
}
