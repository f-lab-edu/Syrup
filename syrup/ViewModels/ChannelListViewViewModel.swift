import Foundation
protocol DataDelegate: AnyObject {
    func didUpdateData(_ data: [ChannelModel])
}


final class ChannelListViewViewModel {
    private let channelService: ChannelServiceable = ChannelService()
    weak var delegate: DataDelegate?
    var channelList: [ChannelModel] = [ChannelModel]() {
        didSet {
            delegate?.didUpdateData(channelList)
        }
    }
    
    func createChannel(aiServiceType: AIServiceType) async throws {
        try await channelService.createChannel(aiServiceType: .geminiAI)
    }
    
    func getChannels() async throws {
        let channels = try await channelService.getChannels()
        guard let channels = channels else { return }
        channelList = channels
        print(channelList.count)
    }
    
    func deleteChannel() async throws {
        try await channelService.deleteChannel()
    }
    
//    func listenForChannelChanges() {
//        channelService.listenForChannelChanges()
//    }
    
//    func deleteChannel(completion: @escaping (Result<Void, Error>) -> Void) {
//        channelService.deleteChannel { result in
//            switch result {
//            case .success:
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}

