//
//  PopUpOneViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 15/03/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class PopUpOneViewController: UIViewController {
    weak var popUpOneDelegate: PopUpOneDelegate?
    @IBOutlet weak var manageYesBtn: UIButton!
    @IBOutlet weak var manageNoBtn: UIButton!
    @IBOutlet weak var linkYesBtn: UIButton!
    @IBOutlet weak var linkNoBtn: UIButton!

    @IBAction func paymntYesClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.popUpOneDelegate?.paymentYesClicked()
        self.manageYesBtn.backgroundColor = UIColor.init(red: 32/255, green: 48/255, blue: 127/255, alpha: 1)
        self.manageYesBtn.setTitleColor(UIColor.white, for: .normal)
        self.manageNoBtn.backgroundColor = UIColor.lightGray
        self.manageNoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
//        self.manageNoBtn.setTitleColor(UIColor.blue, for: .normal)
    }
    @IBAction func paymentNoClicked(_ sender: Any) {
       // navigationController?.popViewController(animated: true)
       // dismiss(animated: true, completion: nil)
        self.popUpOneDelegate?.paymentYesClicked()
        self.manageNoBtn.backgroundColor = UIColor.init(red: 32/255, green: 48/255, blue: 127/255, alpha: 1)
        self.manageNoBtn.setTitleColor(UIColor.white, for: .normal)
        self.manageYesBtn.backgroundColor = UIColor.lightGray
        self.manageYesBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
//        self.manageYesBtn.setTitleColor(UIColor.blue, for: .normal)
    }

    @IBAction func linkParentNoClicked(_ sender: Any) {
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
        self.popUpOneDelegate?.linkParentNoClicked()
        self.linkNoBtn.backgroundColor = UIColor.init(red: 32/255, green: 48/255, blue: 127/255, alpha: 1)
        self.linkNoBtn.setTitleColor(UIColor.white, for: .normal)
        self.linkYesBtn.backgroundColor = UIColor.lightGray
        self.linkYesBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
//        self.linkYesBtn.setTitleColor(UIColor.blue, for: .normal)
    }
    @IBAction func linkParentYesClicked(_ sender: Any) {
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
        self.popUpOneDelegate?.linkParentYesClicked()
        self.linkYesBtn.backgroundColor = UIColor.init(red: 32/255, green: 48/255, blue: 127/255, alpha: 1)
        self.linkYesBtn.setTitleColor(UIColor.white, for: .normal)
        self.linkNoBtn.backgroundColor = UIColor.lightGray
        self.linkNoBtn.setTitleColor(UIColor.blue, for: .normal)
        self.linkNoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()         
        // Do any additional setup after loading the view.
        self.manageYesBtn.backgroundColor = UIColor.init(red: 32/255, green: 48/255, blue: 127/255, alpha: 1)
        self.manageYesBtn.setTitleColor(UIColor.white, for: .normal)
        self.manageNoBtn.backgroundColor = UIColor.lightGray
        self.manageNoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
//        self.manageNoBtn.setTitleColor(UIColor.blue, for: .normal)
        self.linkYesBtn.backgroundColor = UIColor.init(red: 32/255, green: 48/255, blue: 127/255, alpha: 1)
        self.linkYesBtn.setTitleColor(UIColor.white, for: .normal)
        self.linkNoBtn.backgroundColor = UIColor.lightGray
        self.linkNoBtn.setTitleColor(UIColor(red: 41/255.0, green: 56/255.0, blue: 133/255.0, alpha:1.0), for: .normal)
//        self.linkNoBtn.setTitleColor(UIColor.blue, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
