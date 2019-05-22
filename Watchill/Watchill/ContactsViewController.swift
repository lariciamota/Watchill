//
//  ViewController.swift
//  Watchill
//
//  Created by Laricia Mota on 10/05/19.
//  Copyright © 2019 Laricia Mota. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contactsTableView: UITableView!
    
    var favoriteViewController: FavoriteContactsViewController!
    
    func fetchContacts(){
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("Erro ao pedir acesso aos contatos:", error)
                return
            }
            
            if (granted) {
                print("Acesso liberado")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    var newContacts: [Int: [Contact]] = [:]
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        let char: Character = contact.givenName.uppercased().folding(options: .diacriticInsensitive, locale: .current).first ?? "#"
                        let index = self.letterToNumber[char] ?? 26
                        let newContact = Contact(name: contact.givenName + " " + contact.familyName, phone: contact.phoneNumbers.first?.value.stringValue ?? "")
                        if var value = newContacts[index] {
                            value.append(newContact)
                            newContacts[index] = value
                        } else {
                            newContacts[index] = [newContact]
                        }
                    })
                   
                    for (index, contacts) in newContacts {
                        newContacts[index] = contacts.sorted(by: { (c0, c1) -> Bool in
                            (c0.name) <= (c1.name)
                        })
                    }
                    
                    self.contacts = newContacts
                } catch let error {
                    print("Erro ao pegar contatos:", error)
                }
                
                
            } else {
                print("Acesso recusado")
            }
        }
    }
    
    var contacts: [Int: [Contact]] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.contactsTableView.reloadData()
            }
        }
    }
    
    let alphabet = Alphabet.allCases
    
    var letterToNumber: [Character: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactsTableView.dataSource = self
        self.contactsTableView.delegate = self
        
        for (index,letter) in self.alphabet.enumerated() {
            letterToNumber[letter.rawValue] = index
        }
        
        var newContacts: [Int: [Contact]] = [:]
        for (index,_) in self.alphabet.enumerated() {
            newContacts[index] = []
        }
        contacts = newContacts

        fetchContacts()
        
        contactsTableView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.87, alpha:1.0)
        contactsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let letters = Alphabet.allCases
        
        for (index,letter) in letters.enumerated() {
            if section == index {
                return String(letter.rawValue)
            }
        }
        return String(Alphabet.other.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for c in contacts {
            print(c.key)
        }
        print("fim")
        return contacts[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contact = contacts[indexPath.section] {
            favoriteViewController.addFavorite(favorite: Contact(name: contact[indexPath.row].name, phone: contact[indexPath.row].phone))
            navigationController?.popViewController(animated: true)
        } else {
            print("Nao foi possivel salvar esse contato.")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
        let contact = contacts[indexPath.section]![indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.phoneLabel.text = contact.phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red:0.95, green:0.95, blue:0.87, alpha:1.0)
        header.backgroundView?.backgroundColor = UIColor(red:0.15, green:0.42, blue:0.45, alpha:1.0)

    }
    
}
