import Foundation

final class AIServicFactory {
    static func createAIRepository(for type: AIServiceType) -> AIServiceable {
        switch type {
        case .geminiAI:
            return GeminiAIRepository()
        }
    }
}

