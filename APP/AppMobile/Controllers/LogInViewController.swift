//
//  LogInViewController.swift
//  FiekAppGr53
//
//  Created by Enis Hoxha on 2/20/24.
//  Copyright © 2024 Enis Hoxha. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    var loggedInUsername: String?
    var loggedInPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInAction(sender: UIButton){
            guard let enteredUsername = username.text, !enteredUsername.isEmpty,
                  let enteredPassword = password.text, !enteredPassword.isEmpty else {
                showAlert(title: "Incomplete Information", message: "Please enter both username and password.")
                return
            }

            if let user = LogInViewController.fetchUser(withUsername: enteredUsername, andPassword: enteredPassword) {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.loggedInUsername = enteredUsername
                appDelegate.loggedInPassword = enteredPassword
                performSegue(withIdentifier: "showCustomTableView", sender: self)
            } else {
                showAlert(title: "Incorrect Credentials", message: "Please try again.")
            }
    }
    
    static func fetchUser(withUsername username: String?, andPassword password: String?) -> User? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username ?? "", password ?? "")

        do {
            let results = try context.fetch(request) as! [User]
            return results.first
        } catch {
            print("Fetch failed: \(error)")
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCustomTableView" {
            let customTableViewController = segue.destination as! CustomTableViewController
            customTableViewController.loggedInUsername = loggedInUsername
            customTableViewController.loggedInPassword = loggedInPassword
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
