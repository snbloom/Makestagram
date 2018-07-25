//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Sarah Bloom on 7/12/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateNewUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nextButtonOutlet.layer.cornerRadius = 6
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else {return}
        
        UserService.create(firUser, username : username) { (user) in
            guard let user = user else{
                return
            }
            
            print("Created new user: \(user.username)")
        }
        
        UserService.create(firUser, username: username) {(user) in
            guard let _ = user else{
                return
            }
            
            let storyboard = UIStoryboard(name:"Main", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
