//
//  ViewController.swift
//  FCMChat
//
//  Created by Georgekutty Joy on 02/04/18.
//  Copyright © 2018 Georgekutty Joy. All rights reserved.
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
              //  let name        = data["sender_name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: "", text: text)
                {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    @IBAction func didTapBackButton(_ sender: Any) {
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
            
            let userName = String(describing: UserDefaults.standard.value(forKey: "bP_userName") ?? "")
            let ChatuserName = self.recentChatDic["receiver_name"]!
            if userName == ChatuserName {
                title = "Messages with " + self.recentChatDic["sender_name"]!
            }
            else{
               title = "Messages with " + self.recentChatDic["receiver_name"]!
            }
        }
         else{
            let connectedUserModelOfFirstElement = connectedUserModel.first
            title = "Messages with " + (connectedUserModelOfFirstElement?.connectedUser?.firstName)!
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
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
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
            receiver_name = String((connectedUserModelOfFirstElement?.connectedUser?.firstName)!)
            receiver_id = String((connectedUserModelOfFirstElement?.connectedUser?.userId ?? 0))
            profileImg = String ((connectedUserModelOfFirstElement?.connectedUser?.imageUrl)!)
        }
        
        let chatDate:String = String (describing: date!)
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

