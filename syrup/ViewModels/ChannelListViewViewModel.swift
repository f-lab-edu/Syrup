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
    
    func deleteChannel() {
        channelService.deleteChannel()
    }
}

