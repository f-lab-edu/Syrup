import UIKit

protocol ChannelViewViewModelDelegate: AnyObject {
    func didUpdateData(_ viewModel: ChannelViewViewModel)
}

final class ChannelViewViewModel {
    private var aiService: AIServiceable
    var messages: [MessageModel] {
        return aiService.messages
    }
    weak var delegate: ChannelViewViewModelDelegate?
    
    init(_ channelID: String) {
        aiService = AIServiceFactory.createAIRepository(for: .geminiAI, channelID)
        aiService.delegate = self
    }
    
    
    func sendMessage(_ message: String, _ channelID: String) {
        print("send message vm")
        aiService.sendMessage(message, channelID)
    }
    
    func getMessages(_ channelID: String) {
        print("get messages vm")
        Task {
            do {
                try await aiService.getMessages(channelID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ChannelViewViewModel: AIServiceDelegate {
    func didMessageListUpdate(_ service: AIServiceable) {
        delegate?.didUpdateData(self)
    }
}
