import Foundation
import FirebaseFirestore
import Combine

enum FirestoreCollection: String {
    case channels
    case users
}

protocol FirestoreRepositoryChannelDelegate: AnyObject {
    func didUpdateChannelList(_ repository: FirestoreRepository)
}

protocol FirestoreRepositoryMessageDelegate: AnyObject {
    func didUpdateMessageList(_ repository: FirestoreRepository)
}
//싱글턴일 필요가 없음
//Extension File 분리
//추후에는 FirestoreRepository의 역할 고민 (하나에서 너무 많은걸 하고있음)
final class FirestoreRepository {
    weak var channelDelegate: FirestoreRepositoryChannelDelegate?
    weak var messageDelegate: FirestoreRepositoryMessageDelegate?
    static let shared = FirestoreRepository()
    private let db: Firestore
    private var channelListener: ListenerRegistration?
    private var messageListener: ListenerRegistration?
    
    private init() {
        db = Firestore.firestore()
    }
    
    private func documentReferenceForCollection(collectionName: FirestoreCollection, documentID: String) -> DocumentReference {
        return db.collection(collectionName.rawValue).document(documentID)
    }
    
    func saveMessage(_ message: MessageModel, _ channelID: String) async throws {
        print("save Message FirestoreRepo")
        let channelsRef = db.collection(FirestoreCollection.channels.rawValue)
        let channelDoc = channelsRef.document(channelID)
        
        var messageData: [String: Any] = [
             "content": message.content,
             "sender": message.sender.rawValue,
             "timestamp": message.timestamp
         ]

        if let error = message.error {
            messageData["error"] = error.localizedDescription
        }
         try await channelDoc.updateData(["messages": FieldValue.arrayUnion([messageData])])
    }
    
    func getMessages(for channelID: String) async throws -> [MessageModel] {
        print("getMessages Firestore")
        let channelsRef = db.collection(FirestoreCollection.channels.rawValue)
        let channelDocRef = channelsRef.document(channelID)
        let documentSnapshot = try await channelDocRef.getDocument()
        
        guard let messagesData = documentSnapshot.data()?["messages"] as? [[String: Any]] else {
            print("No messages found or messages are not in the expected format.")
            return []
        }
        
        let messages = MessageModel.createMessageModels(from: messagesData)
        return messages
    }

    
    func createChannel(channel: ChannelModel) async throws {
        let docRef = documentReferenceForCollection(collectionName: .channels, documentID: channel.channelID)
        let dto = ChannelDTO(from: channel)
        print(dto.toDictionary())
        try await docRef.setData(dto.toDictionary())
    }
    

    func getChannels(currentUserUID: String) async throws -> [ChannelModel]? {
        let channelsRef = db.collection(FirestoreCollection.channels.rawValue)
        let query = channelsRef.whereField("uid", isEqualTo: currentUserUID)
        let snapshot = try await query.getDocuments()
        let data = snapshot.documents.compactMap { document in
            return ChannelDTO(data: document.data())?.toModel()
        }
        return data
    }

    func deleteChannel(channelID: String) async throws {
        let docRef = documentReferenceForCollection(collectionName: .channels, documentID: channelID)
        try await docRef.delete()
    }
    
    func listenForChannelChanges(userID: String) {
        let channelsRef = db.collection(FirestoreCollection.channels.rawValue)
        let query = channelsRef.whereField("uid", isEqualTo: userID)

        channelListener = query.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot: \(error!)")
                return
            }
            let _ = snapshot.documents.compactMap { document in
                return ChannelDTO(data: document.data())?.toModel()
            }
            self.channelDelegate?.didUpdateChannelList(self)
        }
    }
    
    func listenForMessageChanges(channelID: String) {
        let channelDocRef = db.collection(FirestoreCollection.channels.rawValue)
                              .document(channelID)

        messageListener = channelDocRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching channel snapshot: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            print("신규 메세지 \(document.data()!)")
            
            if let messagesData = document.data()?["messages"] as? [[String: Any]] {
                self.messageDelegate?.didUpdateMessageList(self)
            } else {
                print("No messages found or the format is incorrect")
            }
        }
    }

    
    func removeChannelListener() {
        channelListener?.remove()
        channelListener = nil
    }
    
    func removeMessageListener() {
        messageListener?.remove()
        messageListener = nil
    }
}

//MARK: User data database
extension FirestoreRepository {
    func saveUserData(userResult: UserModel) {
        let docRef = documentReferenceForCollection(collectionName: .users, documentID: userResult.uid)
        docRef.setData(["userEmail": userResult.userEmail, "userName": userResult.userDisplayName, "uid": userResult.uid])
    }
    
    func checkUserDataExists(userUID: String) async -> Bool {
        let docRef = documentReferenceForCollection(collectionName: .users, documentID: userUID)
        
        do {
            let snapshot = try await docRef.getDocument()
            return snapshot.exists
        } catch {
            print("Error checking user data existence: \(error.localizedDescription)")
            return false
        }
    }
}
