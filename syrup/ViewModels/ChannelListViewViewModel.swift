import Foundation


final class ChannelListViewViewModel {
    private let channelService: ChannelServiceable = ChannelService()
    
    func listenForChannelChanges() {
        channelService.listenForChannelChanges()
    }
    
    func createChannel(aiServiceType: String) {
        channelService.createChannel(aiServiceType: aiServiceType)
    }
    
    func getChannel() {
        channelService.getChannels()
    }
    
    func deleteChannel() {
        channelService.deleteChannel()
    }
}

