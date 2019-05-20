//
//  ViewController.swift
//  Watchill
//
//  Created by Danilo da Rocha Lira Araujo on 09/05/19.
//  Copyright © 2019 Danilo da Rocha Lira Araujo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(x))
        view.addGestureRecognizer(tap)
    
        
    }
    
    @objc func x(){
        print("b")
    }

    @IBAction func acessarContatos(_ sender: UIButton) {
        
        print("a")
        
    }
    
}

