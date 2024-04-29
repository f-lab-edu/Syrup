import Foundation

final class AIServicFactory {
    static func createAuthService(for type: AIServiceType) -> AIServiceable {
        switch type {
        case .geminiAI:
            return GeminiAIRepository()
        }
    }
}

