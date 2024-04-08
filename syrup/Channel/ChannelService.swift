import Foundation

protocol ChannelServiceable {
    func createChannel(aiServiceType: AIServiceType)
    func getChannels()
    func listenForChannelChanges()
    func deleteChannel()
}

final class ChannelService: ChannelServiceable {
    func listenForChannelChanges() {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        FirestoreRepository.shared.listenForChannelChanges(currentUserUID: currentUser.uid)
    }
    
    
    private func getCurrentUser() -> UserModel? {
        let firebaseAuthRepo = FirebaseAuthRepository()
        return firebaseAuthRepo.getUserResultModel()
    }
    
    func deleteChannel() {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        FirestoreRepository.shared.deleteChannel(currentUserUID: currentUser.uid)
    }
    
    func getChannels() {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        FirestoreRepository.shared.getChannels(currentUserUID: currentUser.uid)
    }
    
    func createChannel(aiServiceType: AIServiceType) {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        
        let channelModel = ChannelModel(channelID: UUID().uuidString, uid: currentUser.uid, aiServiceType: aiServiceType)
        FirestoreRepository.shared.createChannel(channel: channelModel)
    }
}
