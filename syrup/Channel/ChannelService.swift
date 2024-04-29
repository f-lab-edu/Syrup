import Foundation
import Combine

protocol ChannelServiceable {
    var channels: [ChannelModel] { get }
    var delegate: ChannelServiceDelegate? { get set }
    
    func createChannel(aiServiceType: AIServiceType) async throws
    func deleteChannel(at channelID: String) async throws
}


protocol ChannelServiceDelegate: AnyObject {
    func didChannelsUpdate(_ service: ChannelService)
}

final class ChannelService: ChannelServiceable {

    var channels: [ChannelModel] = [ChannelModel]()
    weak var delegate: ChannelServiceDelegate?

    private func getCurrentUser() -> UserModel? {
        let firebaseAuthRepo = FirebaseAuthRepository()
        return firebaseAuthRepo.getUserResultModel()
    }

    
    init() {
        FirestoreRepository.shared.channelDelegate = self
        let currentUser = getCurrentUser()
        FirestoreRepository.shared.listenForChannelChanges(userID: currentUser!.uid)
    }
    
    func deleteChannel(at channelID: String) async throws {
        try await FirestoreRepository.shared.deleteChannel(channelID: channelID)
    }
    
    func createChannel(aiServiceType: AIServiceType) async throws {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        
        let channelModel = ChannelModel(channelID: UUID().uuidString, uid: currentUser.uid, aiServiceType: aiServiceType)
        try await FirestoreRepository.shared.createChannel(channel: channelModel)
    }
}

extension ChannelService: FirestoreRepositoryChannelDelegate {
    func didUpdateChannelList(_ repository: FirestoreRepository) {
        let currentUser = getCurrentUser()
        guard let currentUser = currentUser else { return }
        Task {
            do {
                let channelData = try await repository.getChannels(currentUserUID: currentUser.uid)
                self.channels = channelData ?? []
                self.delegate?.didChannelsUpdate(self)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
