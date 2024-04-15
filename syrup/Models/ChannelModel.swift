import Foundation

enum AIServiceType: String {
    case geminiAI = "geminiAI"
}

struct ChannelModel {
    let channelID: String
    let uid: String
    let aiServiceType: AIServiceType
}

struct ChannelDTO {
    var channelID: String
    var uid: String
    var aiServiceType: String

    init(from model: ChannelModel) {
        self.channelID = model.channelID
        self.uid = model.uid
        self.aiServiceType = model.aiServiceType.rawValue
    }

    init?(data: [String: Any]) {
        guard let channelID = data["channelID"] as? String,
              let uid = data["uid"] as? String,
              let aiServiceType = data["aiServiceType"] as? String else {
            return nil
        }
        self.channelID = channelID
        self.uid = uid
        self.aiServiceType = aiServiceType
    }

    func toDictionary() -> [String: Any] {
        return [
            "channelID": channelID,
            "uid": uid,
            "aiServiceType": aiServiceType
        ]
    }

    func toModel() -> ChannelModel? {
        guard let serviceType = AIServiceType(rawValue: aiServiceType) else {
            return nil
        }
        return ChannelModel(channelID: channelID, uid: uid, aiServiceType: serviceType)
    }
}



