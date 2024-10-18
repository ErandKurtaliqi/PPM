//
//  NewNoteViewController.swift
//  FiekAppGr53
//
//  Created by Enis Hoxha on 2/26/24.
//  Copyright © 2024 Enis Hoxha. All rights reserved.
//

import UIKit
import CoreData

class NewNoteViewController: UIViewController {
    
    @IBOutlet var titleNote: UITextField!
    @IBOutlet var contentNote: UITextField!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedNote != nil){
            titleNote.text = selectedNote?.title
            contentNote.text = selectedNote?.content
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(_ sender: Any){
        guard let loggedInUsername = (UIApplication.shared.delegate as? AppDelegate)?.loggedInUsername,
              let loggedInPassword = (UIApplication.shared.delegate as? AppDelegate)?.loggedInPassword else {
            print("No logged-in user")
            return
        }

        if let loggedInUser = LogInViewController.fetchUser(withUsername: loggedInUsername, andPassword: loggedInPassword) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            if(selectedNote == nil){
                let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
                let newNote = Note(entity: entity!, insertInto: context)
                newNote.id = noteList.count as NSNumber
                newNote.title = titleNote.text
                newNote.content = contentNote.text
                        
                newNote.user = loggedInUser
                        
                do {
                    try context.save()
                    noteList.append(newNote)
                    navigationController?.popViewController(animated: true)
                } catch { print("context save error") }
            } else {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                    
                do {
                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let note = result as! Note
                        if(note == selectedNote){
                            note.title = titleNote.text
                            note.content = contentNote.text
                            try context.save()
                            navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    print ("Fetch failed")
                }
            }
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
