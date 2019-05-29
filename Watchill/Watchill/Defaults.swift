//
//  Defaults.swift
//  Watchill
//
//  Created by Laricia Mota on 10/05/19.
//  Copyright © 2019 Laricia Mota. All rights reserved.
//

import Foundation

class Defaults{
    
    let defaults = UserDefaults.standard
    static let shared: Defaults = Defaults()
    let contactKey = "contactsKey"
    
    var contacts: [Contact]{
        get{
            let data = defaults.value(forKey: contactKey) as! Data
            let contactsSaved = try! PropertyListDecoder().decode([Contact].self, from: data)
            return contactsSaved
        }
        set(newContacts){
            let encodedArray = try! PropertyListEncoder().encode(newContacts)
            defaults.set(encodedArray, forKey: contactKey)
        }
    }
    
    private init(){
        if defaults.value(forKey: contactKey) == nil{
            let array: [Contact] = []
            let encodedArray = try! PropertyListEncoder().encode(array)
            defaults.set(encodedArray, forKey: contactKey)
        }
    }
    
}
