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
    let dateFormatter = DateFormatter()
    let formatter = DateFormatter()
    let formatter1 = DateFormatter()
    let dateFormatter1 = DateFormatter()
    let dateFormatter2 = DateFormatter()
    let dateFormatter3 = DateFormatter()
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
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter3.dateFormat = "yyyy-MM-dd hh:mm:ss"
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        userChatID = creatreChatId()
        configUser()
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let databaseRoot = Database.database().reference(withPath: "test-messages")
        let databaseChats  = databaseRoot.child(userChatID)
        let query = databaseChats.queryLimited(toLast: 5050)
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let msgDate        = data["date"],
                let text        = data["text"],
                !text.isEmpty
            {
                var dateForChat = self?.dateFormatter.date(from: msgDate)
                
                if (self?.dateFormatter1.date(from: msgDate)) != nil{
                    dateForChat = self?.dateFormatter1.date(from: msgDate)
                }
                else if (self?.dateFormatter2.date(from: msgDate)) != nil{
                    dateForChat = self?.dateFormatter2.date(from: msgDate)
                }
                else if (self?.dateFormatter3.date(from: msgDate)) != nil{
                    dateForChat = self?.dateFormatter3.date(from: msgDate)
                }
                else if (self?.dateFormatter.date(from: msgDate)) != nil{
                    dateForChat = self?.dateFormatter.date(from: msgDate)
                }
                
                if dateForChat != nil{
                    if let message = JSQMessage(senderId: id, senderDisplayName: "", date: dateForChat, text: text)
                    {
                        self?.messages.append(message)
                        self?.finishReceivingMessage()
                    }
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
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        print(messages[indexPath.item])
        let chatDate = messages[indexPath.item].date
        let dateForChat = dateFormatter.string(from: chatDate!)
        let temp = dateFormatter.date(from: dateForChat)
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let showDate1 = formatter.string(from: temp!)
        let showDate = UTCToLocal(date: showDate1)
        return NSAttributedString(string: showDate)
    }
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        print(messages[indexPath.item],indexPath.item)
        let chatDate = messages[indexPath.item].date
        let dateForChat = dateFormatter.string(from: chatDate!)
        let temp = dateFormatter.date(from: dateForChat)
        formatter1.dateFormat = "dd-MMM-yyyy"
        formatter1.timeZone = TimeZone(identifier: "UTC")
        let showDate = formatter1.string(from: temp!)
        var previouseMessageDate : Date
        var previouseDay : Int
        let day = Calendar.current.component(.day, from: chatDate!)
        print(messages[indexPath.row].text,messages[indexPath.item].date)
        if indexPath.item == 0 {
            previouseDay = 0
        }
        else {
            previouseMessageDate = messages[indexPath.item - 1].date
            previouseDay = Calendar.current.component(.day, from: previouseMessageDate)
        }
    
        if day == previouseDay && indexPath.item != 0 {
            return nil
        }
        else {
            let today = Calendar.current.isDateInToday(temp!)
            let yesterday = Calendar.current.isDateInYesterday(temp!)
            if today{
                return NSAttributedString(string: "Today")
            }
            else if yesterday {
                return NSAttributedString(string: "Yesterday")
            }
            else{
                return NSAttributedString(string: showDate)
            }
        }
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
         return 15
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return 15
    }
    
    
    // MARK: - Send button Action
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
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
        
        let mDate = Date()
        let nameOfMonth1 = dateFormatter.string(from: mDate)
        let nameOfMonth = localToUTC(date: nameOfMonth1)
        let chatDate:String = String (describing: nameOfMonth)
        let databaseRoot = Database.database().reference(withPath: "test-messages")
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
  // if let message = JSQMessage(senderId: id, displayName: "", text: text)
