//
//  NewFriendViewController.swift
//  FriendsApp
//
//  Created by Chirag Dodia on 4/19/25.
//

import UIKit

class NewFriendViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField:  UITextField!
    @IBOutlet weak var emailTextField:     UITextField!
    
    private var model: FriendsModel {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve AppDelegate")
        }
        return appDelegate.friendsModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Friend"
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate  = self
        emailTextField.delegate     = self
    }
    
    // MARK: – IBAction
    @IBAction func addFriendTapped(_ sender: UIButton) {
        guard
            let first = firstNameTextField.text, !first.isEmpty,
            let last  = lastNameTextField.text,  !last.isEmpty,
            let email = emailTextField.text,     !email.isEmpty
        else {
            let alert = UIAlertController(
                title: "Missing Info",
                message: "Please fill in First Name, Last Name, and Email.",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        model.addFriend(firstName: first, lastName: last, email: email)
        model.saveToDisk()
        
        if let splitVC = self.splitViewController,
           let masterNav = splitVC.viewControllers.first as? UINavigationController,
           let friendsTableVC = masterNav.topViewController as? FriendsTableViewController {
            friendsTableVC.reloadData()
        }
        
        firstNameTextField.text = ""
        lastNameTextField.text  = ""
        emailTextField.text     = ""
        
        tabBarController?.selectedIndex = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
