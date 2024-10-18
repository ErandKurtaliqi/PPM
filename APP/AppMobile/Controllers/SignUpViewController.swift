//
//  SignUpViewController.swift
//  FiekAppGr53
//
//  Created by Enis Hoxha on 2/27/24.
//  Copyright © 2024 Enis Hoxha. All rights reserved.
//

import UIKit
import CoreData



class SignUpViewController: UIViewController {
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    let data = ["Student", "Professor", "Freelancer", "Working professional", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true

        picker.dataSource = self
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
     @IBAction func signUpAction(_ sender: UIButton) {
         let selectedPosition = data[picker.selectedRow(inComponent: 0)]
        
         if let passwordText = passwordTextField.text, let passwordInt = Int(passwordText) {
             saveUserToCoreData(username: usernameTextField.text,
                                password: NSNumber(value: passwordInt),
                                name: nameTextField.text,
                                position: selectedPosition)
         } else {
             print("Invalid password format")
         }
        
         showAlert(title: "Success", message: "You have successfully signed up!")

         performSegue(withIdentifier: "goToLogin", sender: self)
     }

     func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         alert.addAction(okAction)
         present(alert, animated: true, completion: nil)
     }


    func saveUserToCoreData(username: String?, password: NSNumber?, name: String?, position: String?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        if let existingUser = fetchUser(withUsername: username) {
            print("User with the same username already exists.")
            return
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            else {
            print("Entity not found")
            return
        }

        let newUser = NSManagedObject(entity: entity, insertInto: context) as! User
    
        newUser.id = Int.random(in: 1...1000) as NSNumber
        newUser.username = username ?? ""
        newUser.password = password ?? 0
        newUser.name = name ?? ""
        newUser.position = position ?? ""
        
        do {
            try context.save()
            print("User saved to Core Data")
        } catch {
            print("Save failed")
        }
    }

    func fetchUser(withUsername username: String?) -> User? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "username == %@", username ?? "")

        do {
            let results = try context.fetch(request) as! [User]
            return results.first
        } catch {
            print("Fetch failed")
            return nil
        }
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

extension SignUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension SignUpViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}
