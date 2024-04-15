import Foundation
import FirebaseFirestore
import Combine

enum FirestoreCollection: String {
    case channels
    case users
}

final class FirestoreRepository {
    static let shared = FirestoreRepository()
    private let db: Firestore
//    private var channelListener: ListenerRegistration?
    private var channelListnerDict: [String: ListenerRegistration] = [String: ListenerRegistration]()
    
    private init() {
        db = Firestore.firestore()
    }
    
    private func documentReferenceForCollection(collectionName: FirestoreCollection, documentID: String) -> DocumentReference {
        return db.collection(collectionName.rawValue).document(documentID)
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
        let snapshot2 = try await query.getDocuments()
        let data = snapshot2.documents.compactMap { document in
            return ChannelDTO(data: document.data())?.toModel()
        }
        return data
    }

    func deleteChannel(currentUserUID: String) async throws {
        let docRef = documentReferenceForCollection(collectionName: .channels, documentID: currentUserUID)
        try await docRef.delete()
    }
    
//    func listenForChannelChanges(userID: String) {
//        let docRef = documentReferenceForCollection(collectionName: .channels, documentID: userID)
//
//        channelListener = docRef.addSnapshotListener { snapshot, error in
//            guard let result = snapshot?.data(), error == nil else {
//                return
//            }
//            print(result)
//        }
//    }
//
//    func removeChannelListener() {
//        channelListener?.remove()
//        channelListener = nil
//    }
}

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
