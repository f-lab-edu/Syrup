import Foundation
//import GoogleGenerativeAI

protocol AIServiceable {
    func sendMessage(_ message: String)
    func getMessages()
}

protocol AIRepositoryDelegate: AnyObject {
    func didSendMessageSuccessfully()
    func didReceiveMessages()
}


final class GeminiAIRepository: AIServiceable {
    private var db: ChatServiceable
    weak var delegate: AIRepositoryDelegate?
    
    private enum GeminiModel: String {
        case geminiPro = "gemini-pro"
    }
    
    init() {
        self.db = FirestoreRepository.shared
    }
    
    func sendMessage(_ message: String) {
        print("Save message AIRepo")
        saveMessage(message)
        let model = GenerativeModel(name: GeminiModel.geminiPro.rawValue, apiKey: APIKey.default)
        let prompt = message
        
        Task {
            do {
                let response = try await model.generateContent(prompt)
                if let text = response.text {
                    print(text)
                    saveMessage(text)
                    self.delegate?.didSendMessageSuccessfully()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getMessages() {
        print("get Messages")
        Task {
            do {
                try await db.getMessages()
                self.delegate?.didReceiveMessages()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveMessage(_ message: String) {
        print("save message Repo")
        Task {
            do {
                try await db.saveMessage(message)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
