//
//  NotesViewController.swift
//  BeachPartner
//
//  Created by krishnapillai on 02/01/1940 Saka.
//  Copyright © 1940 dev. All rights reserved.
//

import UIKit
import DropDown
class NotesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    let dropDown = DropDown()
    private var arrayImage = [AnyHashable]()
    private var i: Int = 0
    var index : Int = 0
    var noOfCells = 0
    var isExpanded = false
    var count: Int = 0
    
    var connectedUserModel: ConnectedUserModel?
    var notes = [GetNoteRespModel]()
//    let dateFormatter = DateFormatter()

    @IBOutlet weak var noNotesLabel: UILabel!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var notesTableview: UITableView!
    @IBAction func menuBtnClicked(_ sender: UIBarButtonItem) {
        dropDown.show()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.noOfCells
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesCell
        cell?.selectionStyle = .none
        
        let note = notes[indexPath.row]

//        let createdDate = Date(timeIntervalSince1970: TimeInterval(note.createdDate/1000))
//        let dateString = dateFormatter.string(from: createdDate)
//        print(dateString)
        
        cell?.timeLabel.text = "Just Now"
        cell?.noteTextView.text = note.note
        
        cell?.deleteNotesBtn.tag = indexPath.row+200000
        cell?.deleteNotesBtn.addTarget(self, action:#selector(deleteBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        cell?.saveBtn.tag = indexPath.row+300000
        cell?.saveBtn.addTarget(self, action:#selector(saveBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell!
    }
    
    
    @objc func deleteBtnClicked(sender:UIButton!) {

        let index = sender.tag-200000
        let note = notes[index]
        
        deleteNote(withId: note.noteId)
    }
    
    @objc func saveBtnClicked(sender:UIButton!) {
        
        let index = sender.tag-300000
        let note = notes[index]
        
        let indexPath = IndexPath(row: index, section: 0)
        let cell = notesTableview.cellForRow(at: indexPath) as! NotesCell
        
        guard let updatedNote = cell.noteTextView.text, updatedNote.count > 0 else { return }
        
        updateNote(withId: note.noteId, noteString: updatedNote)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        didTapAddNoteButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
        
        //        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.hideKeyboardWhenTappedAround()
//        noteButton()
        self.dropDown.anchorView = self.menuBtn
        self.dropDown.dataSource =  ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
        self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
        self.dropDown.width = 150
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            if(item == "My Profile"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "profilevc1") as! CoachProfileTableViewController
                let vc1 = storyboard.instantiateViewController(withIdentifier: "profilevc") as! AthleteProfileTableViewController
                let identifier = UserDefaults.standard.string(forKey: "userType") == "Athlete" ? vc1 : vc
                self.navigationController?.pushViewController(identifier, animated: true)
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
            }

            else if(item == "Logout"){
                self.timoutLogoutAction()
            }
            else if (item == "Settings"){
                let storyboard : UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ComponentSettings") as! SettingsViewController
                controller.SettingsType = "profileSettings"
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else if (item == "Help"){
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                self.present(vc, animated: true, completion: nil)
            }
            else {
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CommmonWebViewController") as! CommmonWebViewController
                vc.titleText = item
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController!.navigationBar.topItem!.title = ""
                self.navigationController?.isNavigationBarHidden = false
                self.present(vc, animated: true, completion: nil)
            }
        }
        self.dropDown.selectRow(0)
    }
    
    private func loadNotes() {
        
        guard let fromId =  Int(UserDefaults.standard.string(forKey: "bP_userId") ?? ""), let toId = connectedUserModel?.connectedUser?.userId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getNotes(fromUserId: fromId, toUserId: toId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let notesModel = responseModel as? GetNoteRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.notes = notesModel.getNoteRespModel
            
            DispatchQueue.main.async {
                
                if self.notes.count == 0 {
                    self.notesTableview.isHidden = true
                    self.noNotesLabel.isHidden = false
                }
                else {
                    self.notesTableview.isHidden = false
                    self.noNotesLabel.isHidden = true
                }
                self.notesTableview.reloadData()
            }
        }, errorResult: { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    private func updateNote(withId noteId: Int, noteString: String) {
        
        guard let userId = connectedUserModel?.connectedUser?.userId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.updateNote(noteId: noteId, note: noteString, toUserId: userId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let noteModel = responseModel as? GetNoteRespModel else {
                print("resp model@@@@@@@@@")
                return
            }
            self.loadNotes()
            
        }, errorResult: { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    

    private func deleteNote(withId noteId: Int) {
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.removeNote(withNoteId: noteId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let notesModel = responseModel as? GetNoteRespModel else {
                print("Rep model does not match")
                return
            }
            
            self.loadNotes()
            
        }, errorResult: { (error) in
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    private func didTapAddNoteButton() {
        guard let connectedUserId = connectedUserModel?.connectedUser?.userId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.postNote(note: " ", toUserId: connectedUserId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()

            guard let noteModel = responseModel as? GetNoteRespModel else { return }
            
            self.loadNotes()
            
        }, errorResult: { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
}




    
    
    
    
    
    


   


