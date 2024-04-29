import UIKit

protocol ChannelViewViewModelDelegate: AnyObject {
    func didUpdateData(_ viewModel: ChannelViewViewModel)
}

final class ChannelViewViewModel {
    private var aiServce: AIServiceable
    var messages: [MessageModel] = [MessageModel]()
    weak var delegate: ChannelViewViewModelDelegate?
    
    init() {
        self.aiServce = GeminiAIRepository()
    }
    
    
    func sendMessage(_ message: String) {
        print("send message vm")
        aiServce.sendMessage(message)
    }
    
    func getMessages() {
        print("get message vm")
        aiServce.getMessages()
    }
}

extension ChannelViewViewModel: AIRepositoryDelegate {
    func didSendMessageSuccessfully() {
        //메세지 성공 처리
        self.delegate?.didUpdateData(self)
    }
    
    func didReceiveMessages() {
        //메세지 페칭 처리
        self.delegate?.didUpdateData(self)
    }
}
