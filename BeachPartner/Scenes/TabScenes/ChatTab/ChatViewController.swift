//
//  ViewController.swift
//  FCMChat
//
//  Created by Beach Partner LLC on 02/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//
import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var userChatID:String!
    var chatType:String!
    var recentChatDic:[String:String]!
    var messages = [JSQMessage]()
    var connectedUserModel = [ConnectedUserModel]()
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor(red: 65/255, green: 78/255, blue: 140/255, alpha: 1))
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor(red: 155/255, green: 164/255, blue: 204/255, alpha: 1))
    }()

   
// MARK: - View Property's
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController!.navigationBar.topItem!.title = ""
        
        super.viewDidLoad()
        userChatID = creatreChatId()
        configUser()
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let databaseRoot = Database.database().reference(withPath: "messages")
        let databaseChats  = databaseRoot.child(userChatID)
        let query = databaseChats.queryLimited(toLast: 25)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let msgDate        = data["date"],
                let text        = data["text"],
                !text.isEmpty
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                let dateForChat = dateFormatter.date(from: msgDate)
                if let message = JSQMessage(senderId: id, senderDisplayName: "", date: dateForChat, text: text)
//                    if let message = JSQMessage(senderId: id, displayName: "", text: text)
                {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
        })
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenSize = UIScreen.main.bounds.size;
            if screenSize.height == 812.0{
                inputToolbar.contentView.textView.becomeFirstResponder()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - User configuration
    
    func creatreChatId() -> String {
         var ChatID = String()
        if chatType == "recentChat"  {
            ChatID = self.recentChatDic["chatId"]!
        return ChatID
        }
        let bP_userId =  Int( UserDefaults.standard.string(forKey: "bP_userId") ?? "")
        
//        let chatUserId = connectedUserModel[0].connectedUser?.userId ?? 0
        let connectedUserModelOfFirstElement = connectedUserModel.first
        let chatUserId = connectedUserModelOfFirstElement?.connectedUser?.userId ?? 0
        if bP_userId!<chatUserId {
            ChatID = UserDefaults.standard.string(forKey: "bP_userId")!+"-"+String(chatUserId)
        }
        else{
            ChatID = String(chatUserId)+"-"+UserDefaults.standard.string(forKey: "bP_userId")!
        }
        
       return ChatID
    }
    
    func configUser()  {
        
         let defaults = UserDefaults.standard
        senderId = UserDefaults.standard.string(forKey: "bP_userId") ?? ""
        senderDisplayName = UserDefaults.standard.string(forKey: "bP_userName") ?? ""
        defaults.set(senderDisplayName, forKey: "jsq_name")
        defaults.set(senderId, forKey: "jsq_id")
        defaults.synchronize()
         if chatType == "recentChat"  {
            
            
            var userName = ""
            if let firstName = self.recentChatDic["sender_name"] {
                userName = firstName + " "
            }
            if let lastName = self.recentChatDic["sender_lastName"] {
                userName = userName + lastName
            }
            title = "Messages with " + userName

        }
         else{
            print("\n\n\n\n///////",connectedUserModel.first ?? " Null")
            let connectedUserModelOfFirstElement = connectedUserModel.first
            
            if let titleName = connectedUserModelOfFirstElement?.connectedUser?.firstName{
                let title1 = "Messages with " + titleName + " "
                if let lastName = connectedUserModelOfFirstElement?.connectedUser?.lastName{
                    title = title1 + lastName
                }
                
            }else {
                title = "Message"
                print("connectedUserModel.first ==>  ",connectedUserModel.first ?? "","\n\nn\n\n connectedUserModel ===00 ",connectedUserModel )
            }
            
        }
    }
    
    // MARK: - Message Bubble property's
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        print(messages[indexPath.item])
        let chatDate = messages[indexPath.item].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateForChat = dateFormatter.string(from: chatDate!)
        return NSAttributedString(string: dateForChat)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
  // MARK: - Send button Action
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
     //   let ref = Constants.refs.databaseChats.childByAutoId()
        var receiver_name:String!
        var receiver_id:String!
        var profileImg:String!
        if chatType == "recentChat"  {
            receiver_name = self.recentChatDic["receiver_name"]!
            receiver_id = self.recentChatDic["receiver_id"]!
            profileImg = self.recentChatDic["profileImg"]!
        }
        else{
             let connectedUserModelOfFirstElement = connectedUserModel.first
            receiver_name = String((connectedUserModelOfFirstElement?.connectedUser?.firstName ?? ""))
            receiver_id = String((connectedUserModelOfFirstElement?.connectedUser?.userId ?? 0))
            profileImg = String ((connectedUserModelOfFirstElement?.connectedUser?.imageUrl)!)
        }
        // code change
        let timestamp = NSDate().timeIntervalSince1970
        let mDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nameOfMonth = dateFormatter.string(from: mDate)
        let chatDate:String = String (describing: nameOfMonth)
        let databaseRoot = Database.database().reference(withPath: "messages")
        let databaseChats  = databaseRoot.child(userChatID)
        let ref = databaseChats.childByAutoId()
       
        let message = ["sender_id": senderId, "sender_name": senderDisplayName, "text": text, "receiver_id":receiver_id, "receiver_name": receiver_name, "date":chatDate,"profileImg":profileImg]
        ref.setValue(message)
        finishSendingMessage()
    }
    
    override func willMove(toParentViewController parent: UIViewController?)
    {
        super.willMove(toParentViewController: parent)
        if parent == nil
        {
            self.navigationController!.navigationBar.topItem!.title = "Connections"
           self.tabBarController?.tabBar.isHidden = false
           
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
//let timestamp = NSDate().timeIntervalSince1970     let date = Date(timeIntervalSince1970: timestamp)
