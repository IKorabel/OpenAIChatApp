//
//  OpenAiChatManager.swift
//  OpenAITest
//
//  Created by Igor Shefer on 17.12.22.
//

import Foundation
import OpenAISwift

class OpenAiChatManager {
    private let apiKey = "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"
    private var openAiApi: OpenAISwift?
    
    init() {
        openAiApi = OpenAISwift(authToken: apiKey)
    }
    
    func sendMessageToOpenAi(message: String, completionHandler: @escaping (Result<OpenAI, OpenAIError>) -> Void) {
        guard let openAiApi else { return }
        openAiApi.sendCompletion(with: message, maxTokens: 500 ,completionHandler: { result in
            completionHandler(result)
        })
    }
}

