import Foundation
import Combine

protocol ChannelServiceable {
    func createChannel(aiServiceType: AIServiceType) async throws
    func getChannels() async throws -> [ChannelModel]?
    //    func listenForChannelChanges()
    func deleteChannel() async throws
}

final class ChannelService: ChannelServiceable {
    private(set) var channels: [ChannelModel] = [ChannelModel]()
    
    private func getCurrentUser() -> UserModel? {
        let firebaseAuthRepo = FirebaseAuthRepository()
        return firebaseAuthRepo.getUserResultModel()
    }
    
    func deleteChannel() async throws {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        try await FirestoreRepository.shared.deleteChannel(currentUserUID: currentUser.uid)
    }
    
    func getChannels() async throws -> [ChannelModel]? {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return nil }
        return try await FirestoreRepository.shared.getChannels(currentUserUID: currentUser.uid)
    }
    
    func createChannel(aiServiceType: AIServiceType) async throws {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        
        let channelModel = ChannelModel(channelID: UUID().uuidString, uid: currentUser.uid, aiServiceType: aiServiceType)
        try await FirestoreRepository.shared.createChannel(channel: channelModel)
    }
    
    
    //    func listenForChannelChanges() {
    //        let currentUser = getCurrentUser()
    //        guard let currentUser = currentUser else { return }
    //        FirestoreRepository.shared.listenForChannelChanges(userID: currentUser.uid)
    //    }
    
    
    
    //    func deleteChannel(completion: @escaping (Result<Void, Error>) -> Void) {
    //        let currentUser = getCurrentUser()
    //        guard let currentUser = currentUser else { return }
    //        FirestoreRepository.shared.deleteChannel(currentUserUID: currentUser.uid) { result in
    //            completion(result)
    //        }
    //    }
    
    //    func getChannels() {
    //        let currentUser = getCurrentUser()
    //        guard let currentUser = currentUser else { return }
    //        FirestoreRepository.shared.getChannels(currentUserUID: <#T##String#>)
    //    }
    
    //    func createChannel(aiServiceType: AIServiceType) {
    //        let currentUser = getCurrentUser()
    //        guard let currentUser = currentUser else { return }
    //
    //        let channelModel = ChannelModel(channelID: UUID().uuidString, uid: currentUser.uid, aiServiceType: aiServiceType)
    //        FirestoreRepository.shared.createChannel(channel: channelModel)
    //    }
}
