//
//  ViewController.swift
//  Median
//
//  Created by 이상윤 on 2017. 6. 21..
//  Copyright © 2017년 이상윤. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class IndexViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate, GIDSignInDelegate {

    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            return
        }
        let authentication = user.authentication
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { ( user, error) in
            if error != nil {
                return
            }
            let userData = ["uid": (user?.uid)!, "name": (user?.displayName)!, "subscribeMediaNotice": true, "subscribeStudentNotice": true, "admin": false] as [String : Any]
            
            let ref = FIRDatabase.database().reference()
            let userRef = ref.child("User").child((user?.uid)!)
            userRef.updateChildValues(userData)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

