//
//  ChoiceInterfaceController.swift
//  Watchill WatchKit Extension
//
//  Created by Laricia Mota on 21/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import WatchKit

class ChoiceInterfaceController: WKInterfaceController {
    var phoneNumber: String = ""
    
    @IBOutlet weak var callButton: WKInterfaceButton!
    
    @IBAction func callNumber() {
        let digitSet = CharacterSet.decimalDigits
        if phoneNumber != "" {
            let numberToCall = String(phoneNumber.unicodeScalars.filter { digitSet.contains($0) })
            guard let number = URL(string: "tel://" + numberToCall) else {
                print("Número inválido.")
                return
            }
            WKExtension.shared().openSystemURL(number)
        } else {
            print("Número inválido.")
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let dict = context as? NSDictionary, let name = dict["name"] as? String, let phone = dict["phone"] as? String {
            let firstName = name.capitalized
            if firstName != "" {
                self.callButton.setTitle("Ligar para " + firstName)
                self.phoneNumber = phone
            } else {
                self.callButton.setTitle("Configurar contato no iPhone")
            }
        }
    }
}
