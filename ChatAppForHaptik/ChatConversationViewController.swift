//
//  ChatConversationViewController.swift
//  ChatAppForHaptik
//
//  Created by kalpesh dhumal on 1/20/17.
//  Copyright © 2017 kalpesh dhumal. All rights reserved.
//

import UIKit

class ChatConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChatDetailsViewModelDelegate{

    var isConnected : Bool = false
    var selectedCells:[Int] = []
    var countTotalMessage = [Int]()
    var messageDetailstableViewData : [ChatDetailsModel] = []
    var userNames = [String]()
    
    var counts:[String:Int] = [:]
    
    @IBOutlet weak var chatDetailsLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    //    let refreshControl = UIRefreshControl()
    var hasNotRefreshed = true
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Chat...")
        return refreshControl
    }()
    
    @IBOutlet weak var chatDetailsTableView: UITableView!
    @IBOutlet weak var messageDetailstableView: UITableView!
    
    var chatDetailsList : [ChatDetailsModel] = []
    
    @IBAction func showChat(_ sender: UITapGestureRecognizer) {
        self.getChatDetails()
    }
    
    @IBAction func showFavourite(_ sender: UITapGestureRecognizer) {
        self.chatDetailsTableView.isHidden = true
        self.messageDetailstableView.isHidden = false
        self.getMessageDetails()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatDetailsTableView.addSubview(self.refreshControl)
   //     isConnected = Utilities.isInternetAvailable()
        
        chatDetailsLabel.layer.borderWidth = 2.0
        chatDetailsLabel.layer.borderColor = UIColor.cyan.cgColor
        chatDetailsLabel.layer.cornerRadius = 8
        chatDetailsLabel.layer.masksToBounds = true
        
        favLabel.layer.borderWidth = 2.0
        favLabel.layer.borderColor = UIColor.cyan.cgColor
        favLabel.layer.cornerRadius = 8
        favLabel.layer.masksToBounds = true
        
        self.chatDetailsTableView.isHidden = false
        self.messageDetailstableView.isHidden = true
        
        
        //       if isConnected {
        //       Utilities.showLoding(view: self.view)
        let chatDetailsViewModelObj = ChatDetailsViewModel()
        chatDetailsViewModelObj.chatDetailsViewModelDelegate = self
        chatDetailsViewModelObj.fetchChatDetailsApiCall()
        //      } else {
        //      Utilities.showErrorAlertView(errorTitle: "Alert", andErrorMessage: "Internet not available")
        //      }
        
    }
    
    func getChatDetails(){
        self.chatDetailsTableView.isHidden = false
        self.messageDetailstableView.isHidden = true
        chatDetailsTableView.reloadData()
    }
    
    func getMessageDetails(){
        
        counts = [:]
        
        messageDetailstableViewData = chatDetailsList.sorted {
            $0.userName! != $1.userName!
        }

        for tempMessageDetailstableViewData in messageDetailstableViewData {
            userNames.append(tempMessageDetailstableViewData.userName!)
            
        }
        
        
        for item in userNames {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        print(counts)
        userNames = userNames.uniq()
        messageDetailstableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
  //      isConnected = Utilities.isInternetAvailable()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refreshing")
        self.getChatDetails()
        refreshControl.endRefreshing()
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows : Int = 0
        if tableView == chatDetailsTableView {
            numberOfRows = chatDetailsList.count
        }else if tableView == messageDetailstableView{
            numberOfRows = userNames.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell1 : ChatDetailsTableViewCell?
        var cell : MessageDetailsCell?
        
        if tableView == chatDetailsTableView {
            cell1 = tableView.dequeueReusableCell(withIdentifier: "chatDetailsCell", for: indexPath as IndexPath) as? ChatDetailsTableViewCell
            if !chatDetailsList.isEmpty {
            let chatDetailsObj = chatDetailsList[indexPath.row]
            
            cell1?.userProfileImageView.layer.cornerRadius = (cell1?.userProfileImageView.frame.size.width)! / 2
            cell1?.userProfileImageView.clipsToBounds = true
            
            if let name = chatDetailsObj.name {
                cell1?.userNameLabel.text = name
                
                if let userProfile = chatDetailsObj.imageURL {
                    NetworkCallHelper.loadImageFromUrl(url: userProfile, view: (cell1?.userProfileImageView)!)
//                }else {
//                
//                let userColor = "#000000"
//                let initialNameImage  = Utilities.setInitialImage(initialName: name + ".",fontSize: 17, backgroundColor: Utilities.HexToColor(hexString: userColor), imageSize: (cell1?.userProfileImageView.bounds.size)!)
//                
//                cell1?.userProfileImageView.image = initialNameImage
                }
                
            }
            if let chatMessage = chatDetailsObj.body {
                cell1?.chatMessageLabel.text = chatMessage
            }
            if let chatTime = chatDetailsObj.messageTime {
            cell1?.chatTimeLabel.text = chatTime
                }

                var rowNums = indexPath.row
                
                var selectedRow:Int
                
                if(selectedCells.count > 0){
                    for tuple in selectedCells{
                        
                        selectedRow = tuple
                        
                        if(selectedRow == rowNums){
                            cell1?.favoritesImageview.image = UIImage(named: "star_selected")
                            break
                        }else{
                            cell1?.favoritesImageview.image = UIImage(named: "Star-un")
                        }
                    }
                }else{
                    cell1?.accessoryType = UITableViewCellAccessoryType.none
                }
            }
            return cell1!
            
        }else if tableView == messageDetailstableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "messageDetailCell", for: indexPath as IndexPath) as? MessageDetailsCell
           
            if !messageDetailstableViewData.isEmpty {
            let userNames = self.userNames[indexPath.row]
            cell?.userNameLabel.text = userNames
                
            let count = counts[userNames]
            cell?.totalMessageLabel.text = "\(count!)"
            
            let favCount  = chatDetailsList.filter({ ($0.userName?.contains(userNames))! && $0.fav == 1 }).count
            
            cell?.totalFavoritesLabel.text = "\(favCount)"
          
            }
            
            return cell!
        }
        
        
        
        
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  selectedRows[indexPath.row] = !selectedRows[indexPath.row]
        
        if tableView == chatDetailsTableView {
            let cell = chatDetailsTableView.cellForRow(at: indexPath) as! ChatDetailsTableViewCell
            
            if !selectedCells.isEmpty {
                if let i = selectedCells.index(where: {$0 == indexPath.row}) {
                    let chatDetailsObj = chatDetailsList[indexPath.row]
                    if chatDetailsObj.fav != 1{
                        cell.favoritesImageview.image = UIImage(named: "star_selected")
                        selectedCells.append(indexPath.row)
                        chatDetailsList[indexPath.row].fav = 1
                    }else{
                        let rowToDelete = indexPath.row
                        
                        for i in 0  ..< selectedCells.count
                        {   if i == 0{
                            if(rowToDelete == selectedCells[i]){
                                selectedCells.remove(at: i)
                                cell.favoritesImageview.image = UIImage(named: "Star-un")
                                chatDetailsList[indexPath.row].fav = 0
                            }
                        }else {
                            if(rowToDelete == selectedCells[i-1]){
                                selectedCells.remove(at: i-1)
                                cell.favoritesImageview.image = UIImage(named: "Star-un")
                                chatDetailsList[indexPath.row].fav = 0
                            }
                        }
                        }
                    }
                }else {
                    cell.favoritesImageview.image = UIImage(named: "star_selected")
                    selectedCells.append(indexPath.row)
                    chatDetailsList[indexPath.row].fav = 1
                }
                
            }else {
                let chatDetailsObj = chatDetailsList[indexPath.row]
                if(chatDetailsObj.fav != 1){
                    cell.favoritesImageview.image = UIImage(named: "star_selected")
                    selectedCells.append(indexPath.row)
                    chatDetailsList[indexPath.row].fav = 1
                }else{
                    let rowToDelete = indexPath.row
                    
                    for i in 0  ..< selectedCells.count
                    {
                        if(rowToDelete == selectedCells[i]){
                            selectedCells.remove(at: i)
                            cell.favoritesImageview.image = UIImage(named: "Star-un")
                            chatDetailsList[indexPath.row].fav = 0
                        }
                    }
                }

            }
            
//            cell.favoritesImageview.image = UIImage(named: "star_selected")
//            let chatDetailsObj = chatDetails[indexPath.row]
//            chatDetailsObj.fav = 1
//            chatDetails[indexPath.row] = chatDetailsObj
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if tableView == chatDetailsTableView {
//            let cell = chatDetailsTableView.cellForRow(at: indexPath) as! ChatDetailsTableViewCell
//            
//            if(cell.accessoryType == UITableViewCellAccessoryType.none){
//                
//                cell.favoritesImageview.image = UIImage(named: "Star_un")
//                selectedCells.append(indexPath.row)
//            }else{
//                let rowToDelete = indexPath.row
//                
//                for i in 0  ..< selectedCells.count
//                {
//                    if(rowToDelete == selectedCells[i]){
//                        selectedCells.remove(at: i)
//                        cell.favoritesImageview.image = UIImage(named: "star_selected")
//                    }
//                }
//            }
//        }
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }

    // Mark - ChatDetailsViewModelDelegate Methods
    
    func fetchChatDetailsSuccessCallBack(data : [ChatDetailsModel]){
   //     Utilities.hideLoader(view: self.view)
        if !data.isEmpty{
            chatDetailsList = data
            self.chatDetailsTableView.isHidden = false
            self.messageDetailstableView.isHidden = true
            self.chatDetailsTableView.reloadData()
        }else{
   //         Utilities.showErrorAlertView(errorTitle: "Alert", andErrorMessage: "Something Went Wrong")
        }
    }
    
    func fetchChatDetailsErrorCallBack(error : Error){
    //    Utilities.hideLoader(view: self.view)
    //    Utilities.showErrorAlertView(errorTitle: "Alert", andErrorMessage: error.localizedDescription)
    }
    
}
