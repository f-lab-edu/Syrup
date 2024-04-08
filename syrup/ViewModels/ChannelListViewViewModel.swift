import Foundation


final class ChannelListViewViewModel {
    private let channelService: ChannelServiceable = ChannelService()
    
    func listenForChannelChanges() {
        channelService.listenForChannelChanges()
    }
    
    func createChannel(aiServiceType: AIServiceType) {
        channelService.createChannel(aiServiceType: .geminiAI)
    }
    
    func getChannel() {
        channelService.getChannels()
    }
    
    func deleteChannel(completion: @escaping (Result<Void, Error>) -> Void) {
        channelService.deleteChannel { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

