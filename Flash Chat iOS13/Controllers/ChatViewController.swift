import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "⚡️FlashChat" // set title for the navigation bar
        navigationItem.hidesBackButton = true
        navigationItem.titleView?.tintColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }

    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,  let sender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: sender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("Add data failed", e)
                } else {
                    print("Successs")
                }
            }
        }
    }
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error sign out", signOutError)
        }
    }
}

extension ChatViewController {
    func loadMessages() {
//        db.collection(K.FStore.collectionName).getDocuments() { QuerySnapshot, Error in //Chỉ gọi 1 lần
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { QuerySnapshot, Error in //Mỗi khi add được cập nhập, nó sẽ gọi lại
            if let e = Error {
                print("Load message failed", e)
            } else {
                self.messages = []
                if let snapshotDoc =  QuerySnapshot?.documents {
                    for doc in snapshotDoc {
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as! String? {
                            let message = Message(sender: sender, body: messageBody)
                            self.messages.append(message)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                         
                    }
                }
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label?.text = messages[indexPath.row].body
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
