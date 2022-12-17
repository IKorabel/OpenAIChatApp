//
//  OpenAiChatViewController.swift
//  OpenAITest
//
//  Created by Igor Shefer on 17.12.22.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class OpenAiChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    var currentSender: MessageKit.SenderType = OpenAiChatSender(senderId: "self", displayName: "You")
    var otherSender: MessageKit.SenderType = OpenAiChatSender(senderId: "openAiBot", displayName: "Genius")
    var messages = [OpenAiChatMessage]() {
        didSet {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    let openAiManager = OpenAiChatManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        print("did started")
        // Do any additional setup after loading the view.
    }
    
    private func configure() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func sendMessage(withText: String,senderType: SenderType) {
        let textWithoutEmptySpaces = withText.trimmingCharacters(in: .whitespacesAndNewlines)
        print("textwithoutEmptySpaces: '\(textWithoutEmptySpaces)'")
        messages.append(.init(sender: senderType, messageId: UUID().uuidString, sentDate: Date(), kind: .text(textWithoutEmptySpaces)))
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

extension OpenAiChatViewController: InputBarAccessoryViewDelegate {
    
    func sendMessageToGenius(withText: String) {
        sendMessage(withText: withText, senderType: currentSender)
        openAiManager.sendMessageToOpenAi(message: withText) { [self] result in
            switch result {
            case .success(let success):
                var answer = success.choices.first?.text ?? ""
                print("answer: ;\(answer);")
                sendMessage(withText: answer, senderType: otherSender)
            case .failure(let failure):
                sendMessage(withText: failure.localizedDescription, senderType: otherSender)
            }
        }
    }
    
    func processInputBar(text: String) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = messageInputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        messageInputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.sendMessageToGenius(withText: text)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    func typingIndicator(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        // To Do
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(text: text)
    }
    
}
