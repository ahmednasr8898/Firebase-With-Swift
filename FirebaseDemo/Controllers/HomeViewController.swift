//
//  HomeViewController.swift
//  FirebaseDemo
//
//  Created by Ahmed Nasr on 11/19/20.
//

import UIKit
import Firebase
import FirebaseAuth

//Main Page for App
class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let ref = Database.database().reference()
    let authUser = Auth.auth()
    var arrOfNotes = [NoteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        checkCurrentUser()
        observData()
    }
    //for check if not found currentUser go to login directly
    func checkCurrentUser(){
        if Auth.auth().currentUser == nil{
            self.goToWithPresent(viewControllerName: "AuthViewController")
        }
    }
    //for get data from database
    func observData(){
        //observer for return all data
        ref.child("Notes").observe(.childAdded){ snap in
            if let value = snap.value as? [String: Any] {
                guard let titleNote = value["titleNote"] as? String, let bodyNote = value["bodyNote"] as? String else{return}
                let note = NoteModel(noteID: snap.key, titleNote: titleNote, bodyNote: bodyNote)
                self.arrOfNotes.append(note)
                self.tableView.reloadData()
            }
        }
    }
    //add new item to database
    @IBAction func addDataOnClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (txt) in txt.placeholder = "titleNote"}
        alert.addTextField { (txt) in txt.placeholder = "bodyNote" }
        //button for add new item
        let addButton = UIAlertAction(title: "add", style: .default) { (_) in
            guard let titleNote = alert.textFields?[0].text, !titleNote.isEmpty, let bodyNote = alert.textFields?[1].text, !bodyNote.isEmpty else{return}
            //Add new item in database
            self.ref.child("Notes").childByAutoId().setValue(["titleNote": titleNote, "bodyNote": bodyNote])}
        alert.addAction(addButton)
        self.present(alert, animated: true, completion: nil)
    }
    //delete all data from database
    @IBAction func deleteAllDataOnClick(_ sender: UIBarButtonItem) {
        ref.child("Notes").removeValue { (error, ref) in
            if error == nil{
                print("delete all data")
                //for upadte data in tableView directly(listen change directly)
                self.arrOfNotes.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    //Sign Out
    @IBAction func signOutOnClick(_ sender: UIBarButtonItem) {
        do{
            try authUser.signOut()
            print("sign out")
            self.goToWithPresent(viewControllerName: "AuthViewController")
        }catch{
            print("error when signOut",error.localizedDescription)
        }
    }
}
//TableView With DataSource
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfNotes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrOfNotes[indexPath.row].titleNote
        cell.detailTextLabel?.text = arrOfNotes[indexPath.row].bodyNote
        return cell
    }
}
//TableView With Delegate
extension HomeViewController: UITableViewDelegate{
    //for delete and update ietm in datebase in tableView
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //for delete item
        let delete = UIContextualAction(style: .destructive, title: "delete") { (_, _, _) in
            //select item for delete
            let noteSelected = self.arrOfNotes[indexPath.row]
            self.ref.child("Notes").child(noteSelected.noteID).removeValue { (error, ref) in
                if error == nil{
                    //for upadte data in tableView directly(listen change directly)
                    print("item is deleted")
                    self.arrOfNotes.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        //for edit item
        let edit = UIContextualAction(style: .normal, title: "edit") {(_, _, _) in
            let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
            alert.addTextField()
            alert.addTextField()
            //select item for edit
            let noteSelected = self.arrOfNotes[indexPath.row]
            alert.textFields?[0].text = noteSelected.titleNote
            alert.textFields?[1].text = noteSelected.bodyNote
            let editButton = UIAlertAction(title: "edit", style: .default) { (_) in
                guard let titleNote = alert.textFields?[0].text, let bodyNote = alert.textFields?[1].text else{return}
                self.ref.child("Notes").child(noteSelected.noteID).updateChildValues(["titleNote": titleNote, "bodyNote":bodyNote],withCompletionBlock: { (error, ref) in
                    if error == nil{
                        //for upadte data in tableView directly(listen change directly)
                        print("item is update")
                        self.arrOfNotes[indexPath.row].titleNote = titleNote
                        self.arrOfNotes[indexPath.row].bodyNote = bodyNote
                        self.tableView.reloadData()
                    }
                })
            }
            alert.addAction(editButton)
            self.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //observeSingleEvent for return single value
        ref.child("Notes").child(arrOfNotes[indexPath.row].noteID).observeSingleEvent(of: .value) { (dataSnapshot) in
            if let value = dataSnapshot.value as? [String: Any]{
                guard let titleNote = value["titleNote"] as? String, let bodyNote = value["bodyNote"] as? String else {return}
                print("titleNote: \(titleNote), bodyNote: \(bodyNote)")
            }
        }
    }
}



