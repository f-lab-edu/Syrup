import Foundation
import FirebaseFirestore

final class FirestoreRepository {
    static let shared = FirestoreRepository()
    private let db: Firestore
    private var channelListener: ListenerRegistration?
    
    private init() {
        db = Firestore.firestore()
    }
    
    private func documentReferenceForCollection(collectionName: String, documentID: String) -> DocumentReference {
        return db.collection(collectionName).document(documentID)
    }
    

    func createChannel(channel: ChannelModel) {
        let docRef = documentReferenceForCollection(collectionName: "channels", documentID: channel.uid)
        docRef.setData(["channelID": channel.channelID, "aiServiceType": channel.aiServiceType])
    }
    
    func getChannels(currentUserUID: String) {
        let docRef = documentReferenceForCollection(collectionName: "channels", documentID: currentUserUID)
        docRef.getDocument { snapshot, error in
            guard let result = snapshot?.data(), error == nil else {
                return
            }
            print(result)
        }
    }
    
    func listenForChannelChanges(currentUserUID: String) {
        let docRef = documentReferenceForCollection(collectionName: "channels", documentID: currentUserUID)
        channelListener = docRef.addSnapshotListener { snapshot, error in
            guard let result = snapshot?.data(), error == nil else {
                return
            }
            print(result)
        }
    }
    
    func removeChannelListener() {
        channelListener?.remove()
        channelListener = nil
    }
    
    func deleteChannel(currentUserUID: String) {
        let docRef = documentReferenceForCollection(collectionName: "channels", documentID: currentUserUID)
        
        docRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
            }
        }
        
    }
}

extension FirestoreRepository {
    func saveUserData(userResult: UserModel) {
        let docRef = documentReferenceForCollection(collectionName: "users", documentID: userResult.uid)
        docRef.setData(["userEmail": userResult.userEmail, "userName": userResult.userDisplayName, "uid": userResult.uid])
    }
    
    func checkUserDataExists(userUID: String) async -> Bool {
        let docRef = documentReferenceForCollection(collectionName: "users", documentID: userUID)
        
        do {
            let snapshot = try await docRef.getDocument()
            print("snapShot! \(snapshot.data())")
            return snapshot.exists
        } catch {
            print("Error checking user data existence: \(error.localizedDescription)")
            return false
        }
    }
}
