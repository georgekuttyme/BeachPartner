//
//  NotesViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 02/01/1940 Saka.
//  Copyright © 1940 Beach Partner LLC. All rights reserved.
//

import UIKit
class NotesViewController: BeachPartnerViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    
    private var arrayImage = [AnyHashable]()
    private var i: Int = 0
    var index : Int = 0
    var noOfCells = 0
    var isExpanded = false
    var count: Int = 0
    var activeTextField: UITextView?
    
    var connectedUserModel: ConnectedUserModel?
    var notes = [GetNoteRespModel]()

    var fromId: Int?
    var toId: Int?
    
    
    var button1 : UIBarButtonItem!
    
    @IBOutlet weak var noNotesLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var notesTableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell?.noteTextView.delegate = self
      

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

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Connections"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let id = UserDefaults.standard.string(forKey: "bP_userId") {
             self.fromId =  Int(id)
        }
        if let id = connectedUserModel?.connectedUser?.userId {
            self.toId = id
        }
        
        loadNotes()
       
        self.hideKeyboardWhenTappedAround()
    }

    //MARK: to enable textview when editing
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        moveTextView(_textView: textView, moveDistance: -100, up: true)
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
//        moveTextView(_textView: textView, moveDistance: -100, up: false)
    }
    
    func textviewShouldReturn(_ textView: UITextView){
        textView.resignFirstResponder()
        
    }
  
    func moveTextView(_textView: UITextView, moveDistance: Int, up:Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    private func loadNotes() {
        
        guard let fromId = fromId, let toId = toId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.getNotes(fromUserId: fromId, toUserId: toId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let notesModel = responseModel as? GetNoteRespModelArray else {
                print("Rep model does not match")
                return
            }
            self.notes = notesModel.getNoteRespModel
            self.notes = self.notes.sorted(by: {$0.createdDate > $1.createdDate })
            
            
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
        
//        guard let userId = connectedUserModel?.connectedUser?.userId else { return }
        
        guard let toId = toId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.updateNote(noteId: noteId, note: noteString, toUserId: toId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()
            guard let noteModel = responseModel as? GetNoteRespModel else {
                print("resp model@@@@@@@@@")
                return
            }
            DispatchQueue.main.async {
            self.loadNotes()
            }
            
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
            
            var refreshAlert = UIAlertController(title: "", message: "Note Deleted Successfully", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            self.present(refreshAlert, animated: true, completion: nil)
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
//        guard let connectedUserId = connectedUserModel?.connectedUser?.userId else { return }
        
        guard let toId = toId else { return }
        
        ActivityIndicatorView.show("Loading...")
        APIManager.callServer.postNote(note: " ", toUserId: toId, sucessResult: { (responseModel) in
            ActivityIndicatorView.hiding()

            guard let noteModel = responseModel as? GetNoteRespModel else { return }
            
            
            DispatchQueue.main.async {
            
            self.loadNotes()
            
            let refreshAlert = UIAlertController(title: "", message: "Note Created", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = self.notesTableview.cellForRow(at: indexPath) as? NotesCell
                if(cell != nil) {
                    cell?.noteTextView.becomeFirstResponder()
                }
             
            }))
            self.present(refreshAlert, animated: true, completion: nil)
            }
            
        }, errorResult: { (error) in
            
            ActivityIndicatorView.hiding()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 128
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeTextField = textView
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: notesTableview)
        var contentOffset:CGPoint = notesTableview.contentOffset
        contentOffset.y  = pointInTable.y - 150
        if let accessoryView = textView.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        notesTableview.contentOffset = contentOffset
        
        return true
    }
}




    
    
    
    
    
    


   


