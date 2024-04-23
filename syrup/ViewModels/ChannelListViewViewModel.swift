import Foundation
protocol DataDelegate: AnyObject {
    func didUpdateData(_ data: [ChannelModel])
}

protocol ChannelErrorDelegate: AnyObject {
    func didEncounterError(_ error: Error)
}



final class ChannelListViewViewModel {
    private let channelService: ChannelServiceable = ChannelService()
    weak var delegate: DataDelegate?
    weak var errorDelegate: ChannelErrorDelegate?
    
    var channelList: [ChannelModel] = [ChannelModel]() {
        didSet {
            delegate?.didUpdateData(channelList)
        }
    }
    
    func createChannel(aiServiceType: AIServiceType) async {
         do {
             try await channelService.createChannel(aiServiceType: .geminiAI)
         } catch {
             errorDelegate?.didEncounterError(error)
         }
     }
     
     func getChannels() async {
         do {
             let channels = try await channelService.getChannels()
             guard let channels = channels else { return }
             channelList = channels
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

