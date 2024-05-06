import Foundation
import FirebaseFirestore

enum SenderType: String {
    case user
    case AI
}

struct MessageModel {
    let content: String
    let sender: SenderType
    let timestamp: Date
    let error: Error?
    
    static func createMessageModels(from data: [[String: Any]]) -> [MessageModel] {
        return data.compactMap { dict in
            guard let content = dict["content"] as? String,
                  let senderString = dict["sender"] as? String,
                  let senderType = SenderType(rawValue: senderString),
                  let timestamp = (dict["timestamp"] as? Timestamp)?.dateValue() else {
                return nil 
            }
            
            return MessageModel(content: content, sender: senderType, timestamp: timestamp, error: nil)
        }
    }
}

