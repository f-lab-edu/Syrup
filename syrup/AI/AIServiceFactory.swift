import Foundation

final class AIServiceFactory {
    static func createAIRepository(for type: AIServiceType, _ channelID: String) -> AIServiceable {
        switch type {
        case .geminiAI:
            return GeminiAIService(channelID)
        }
    }
}

