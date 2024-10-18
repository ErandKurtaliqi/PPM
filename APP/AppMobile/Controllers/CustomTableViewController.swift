//
//  CustomTableViewController.swift
//  FiekAppGr53
//
//  Created by Enis Hoxha on 2/26/24.
//  Copyright © 2024 Enis Hoxha. All rights reserved.
//

import UIKit
import CoreData

var noteList = [Note]()

class CustomTableViewController: UITableViewController {
    
    var firstLoad = true
    var loggedInUsername: String?
    var loggedInPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstLoad {
            firstLoad = false
            guard let loggedInUsername = (UIApplication.shared.delegate as? AppDelegate)?.loggedInUsername,
                  let loggedInPassword = (UIApplication.shared.delegate as? AppDelegate)?.loggedInPassword else {
                print("No logged-in user")
                return
            }
            fetchNotes(withUsername: loggedInUsername, andPassword: loggedInPassword)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchNotes(withUsername username: String, andPassword password: String) {
        guard let loggedInUser = LogInViewController.fetchUser(withUsername: username, andPassword: password) else {
            print("No logged-in user")
            return
        }
        
        if let userNotes = loggedInUser.notes {
            noteList = userNotes.allObjects as! [Note]
        } else {
            noteList = []
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteRow", for: indexPath)
            as! CustomTableViewCell
        
        // Configure the cell...
        cell.lblname.text = noteList[indexPath.row].title
        cell.lblcontent.text = noteList[indexPath.row].content
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool){
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showEditNoteView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "showEditNoteView"){
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NewNoteViewController
            
            let selectedNote : Note!
            selectedNote = noteList[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedNote = noteList[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            context.delete(deletedNote)
            
            do {
                try context.save()
                print("Note deleted from Core Data")
            } catch {
                print("Deletion failed: \(error)")
            }

            noteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
