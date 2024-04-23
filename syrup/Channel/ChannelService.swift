import Foundation
import Combine

protocol ChannelServiceable {
    func createChannel(aiServiceType: AIServiceType) async throws
    func getChannels() async throws -> [ChannelModel]?
    func deleteChannel(at channelID: String) async throws
}

final class ChannelService: ChannelServiceable {
    private(set) var channels: [ChannelModel] = [ChannelModel]()
    
    private func getCurrentUser() -> UserModel? {
        let firebaseAuthRepo = FirebaseAuthRepository()
        return firebaseAuthRepo.getUserResultModel()
    }
    
    func deleteChannel(at channelID: String) async throws {
        try await FirestoreRepository.shared.deleteChannel(channelID: channelID)
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
}
