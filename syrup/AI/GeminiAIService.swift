import Foundation
import GoogleGenerativeAI

protocol AIServiceable {
    var delegate: AIServiceDelegate? { get set }
    var messages:  [MessageModel] { get }
    
    func sendMessage(_ message: String, _ channelID: String)
    func getMessages(_ channelID: String) async throws
}

protocol AIServiceDelegate: AnyObject {
    
//    func didSendMessageSuccessfully(_ service: AIServiceable, message: MessageModel)
//    func didSendMessageFailed(_ service: AIServiceable, message: MessageModel, error: Error)
    func didMessageListUpdate(_ service: AIServiceable)
}


final class GeminiAIService: AIServiceable {
    private var db: FirestoreRepository
    weak var delegate: AIServiceDelegate?
    var messages: [MessageModel] = [MessageModel]()
    private var model: GenerativeModel
    private var channelID: String
    
    private enum GeminiModelName: String {
        case geminiPro = "gemini-pro"
    }
    
    init(_ channelID: String) {
        self.db = FirestoreRepository.shared
        self.model = GenerativeModel(name: GeminiModelName.geminiPro.rawValue, apiKey: ApiKeys.geminiAPIKeys)
        self.channelID = channelID
        db.messageDelegate = self
        db.listenForMessageChanges(channelID: channelID)
    }
    
    deinit {
        db.removeMessageListener()
    }
    
    func getMessages(_ channelID: String) async throws {
        messages = try await db.getMessages(for: channelID)
    }
    
    func sendMessage(_ message: String, _ channelID: String) {
        let prompt = message
        saveMessage(message, channelID, senderType: .user)
        Task {
            do {
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    print("AI TEXT : \(text)")
                    saveMessage(text, channelID, senderType: .AI)
                    //TODO: Model Update가 방법
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    private func saveMessage(_ message: String, _ channelID: String, senderType: SenderType) {
        let messageModel = MessageModel(content: message, sender: senderType, timestamp: Date(), error: nil)
        Task {
            do {
                try await db.saveMessage(messageModel, channelID)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}


extension GeminiAIService: FirestoreRepositoryMessageDelegate {
    func didUpdateMessageList(_ repository: FirestoreRepository) {
        Task {
            do {
                messages = try await repository.getMessages(for: channelID)
                self.delegate?.didMessageListUpdate(self)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
