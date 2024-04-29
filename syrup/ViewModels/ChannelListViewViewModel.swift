import Foundation
protocol ChannelListViewViewModelDelegate: AnyObject {
    func didUpdateData(_ channel: ChannelListViewViewModel)
}

protocol ChannelErrorDelegate: AnyObject {
    func didEncounterError(_ error: Error)
}



final class ChannelListViewViewModel {
    private var channelService: ChannelServiceable
    weak var delegate: ChannelListViewViewModelDelegate?
    weak var errorDelegate: ChannelErrorDelegate?
    
    var channelList: [ChannelModel] {
        return channelService.channels
    }
    
    init() {
        channelService = ChannelService()
        channelService.delegate = self
    }
    
    func createChannel(aiServiceType: AIServiceType) async {
         do {
            try await channelService.createChannel(aiServiceType: .geminiAI)
         } catch {
             errorDelegate?.didEncounterError(error)
         }
     }
     
    func deleteChannel(at index: Int) async {
         do {
             let channelID = self.channelList[index].channelID
             try await channelService.deleteChannel(at: channelID)
         } catch {
             errorDelegate?.didEncounterError(error)
         }
     }
}

extension ChannelListViewViewModel: ChannelServiceDelegate {
    func didChannelsUpdate(_ service: ChannelService) {
        delegate?.didUpdateData(self)
    }

}

