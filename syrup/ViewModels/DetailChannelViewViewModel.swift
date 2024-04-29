import UIKit

protocol DetailChannelViewViewModelDelegate: AnyObject {
    func didUpdateData(_ detailChannel: DetailChannelViewViewModel)
}

final class DetailChannelViewViewModel {
    private var aiServce: AIServiceable
    var messages: [MessageModel] = [MessageModel]()
    weak var delegate: DetailChannelViewViewModelDelegate?
    
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

extension DetailChannelViewViewModel: AIRepositoryDelegate {
    func didSendMessageSuccessfully() {
        //메세지 성공 처리
        self.delegate?.didUpdateData(self)
    }
    
    func didReceiveMessages() {
        //메세지 페칭 처리
        self.delegate?.didUpdateData(self)
    }
}
