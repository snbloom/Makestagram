//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Sarah Bloom on 7/10/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController{
    
    typealias FIRUser = FirebaseAuth.User
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else {return}
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
}

extension LoginViewController: FUIAuthDelegate{
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        guard let user = authDataResult?.user
            else { return }
        
        // 2
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        // 3
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot){
                print("Welcome back \(user.username)")
            }
            else{
                self.performSegue(withIdentifier: "createUsername", sender: self)
            }
        })
        
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let _ = User(snapshot: snapshot) {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
    }
}
