//
//  OpenAiChatMessage.swift
//  OpenAITest
//
//  Created by Igor Shefer on 17.12.22.
//

import Foundation
import MessageKit

struct OpenAiChatMessage: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}
