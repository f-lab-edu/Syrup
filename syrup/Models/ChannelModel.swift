import Foundation

enum AIServiceType: String {
    case geminiAI = "geminiAI"
}

struct ChannelModel {
    let channelID: String
    let uid: String
    let aiServiceType: AIServiceType
}

