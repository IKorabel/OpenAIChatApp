//
//  ImageGenerationManager.swift
//  OpenAITest
//
//  Created by Igor Shefer on 16.12.22.
//

import Foundation
import OpenAIKit
import UIKit

class ImageGeneratorManager {
    private let apiKey = "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"
    
    var imageGenerator: OpenAI?
    
    init() {
        imageGenerator = OpenAI(.init(organization: "Personal", apiKey: apiKey))
    }
    
    func generateImage(withWords: String) async -> UIImage? {
        guard let imageGenerator = imageGenerator else {
            print("OpenAI isn't available")
            return nil
        }
        do {
            let imageParams = ImageParameters(prompt: withWords, resolution: .large, responseFormat: .base64Json)
            let result = try await imageGenerator.createImage(parameters: imageParams)
            let obtainedImageData = result.data[0].image
            let decodedImage = try imageGenerator.decodeBase64Image(obtainedImageData)
            return decodedImage
        } catch let error {
            print("error: \(error.localizedDescription)")
            return nil
        }
    }
}
