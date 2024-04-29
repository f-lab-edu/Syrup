import Foundation

enum SenderType: String {
    case user
    case AI
}

struct MessageModel {
    let content: String
    let sender: SenderType
    let timestmap: Date
}
