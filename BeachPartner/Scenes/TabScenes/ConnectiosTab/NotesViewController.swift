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
       @IBOutlet weak var menuBtn: UIBarButtonItem!
    
      @IBOutlet weak var addBtn: UIButton!
     @IBOutlet weak var notesTableview: UITableView!
    @IBAction func menuBtnClicked(_ sender: UIBarButtonItem) {
        dropDown.show()
    }
    
//      let time = [""]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as? NotesCell
        cell?.timeLabel.text = "Just Now"
        cell?.deleteNotesBtn.addTarget(self, action:#selector(deleteBtnClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        //then make a action method :
        
       
        return cell!
    }
    
    
    @objc func deleteBtnClicked(sender:UIButton!) {
        self.noOfCells = self.noOfCells - 1
        self.notesTableview.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        self.noOfCells = self.noOfCells + 1
        self.notesTableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        noteButton()
        self.dropDown.anchorView = self.menuBtn
        self.dropDown.dataSource =  ["My Profile","About Us","Feedback","Settings", "Help","Logout"]
        self.dropDown.bottomOffset = CGPoint(x: 20, y:45)
        self.dropDown.width = 150
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item:",item," at index:",index)
            if(item == "My Profile"){
                self.performSegue(withIdentifier: "editprofilesegue", sender: self)
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
 
    func noteButton(){
        let id1 = Int(UserDefaults.standard.string(forKey: "bP_userId") ?? "")
        print(index,"index userid ")
        let id2 = index
        APIManager.callServer.getNotes(fromUserId: id1!, toUserId:id2 , sucessResult: {(responseModel) in
            guard let loginModel = responseModel as? GetNoteRespModel else{
                print("Rep model does not match")
                return
            }
            print("FADSGDHDFHDFGHJDGHd",loginModel.fromUser_?.fromUserId)
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    
    }
    func createNoteClicked(){
        let id1 = index
        APIManager.callServer.postNote(note: "This is a test note send to the user",toUserId:id1,sucessResult: {(responseModel) in
            guard let loginModel = responseModel as? UpdateNoteRespModel else{
                print("=====@@@@@")
                return
            }
    
            print("&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@ post",loginModel.id)
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    
    }
    func noteButtonToched(){
        let id1 = "hi testing!!!"
        let id2 = 10
        APIManager.callServer.updateNote(note: id1, toUserId:id2 , sucessResult: {(responseModel) in
            guard let loginModel = responseModel as? UpdateNoteRespModel else{
                print("resp model@@@@@@@@@")
                return
            }
            print("&&&&&&&@@@@@@@@@@@ +++++++++UPdate",loginModel.id)
        }, errorResult: { (error) in
            //                stopLoading()
            guard let errorString  = error else {
                return
            }
            self.alert(message: errorString)
        })
    
    
    }
    func removeNote(){
        
    }

    
    }




    
    
    
    
    
    


   


