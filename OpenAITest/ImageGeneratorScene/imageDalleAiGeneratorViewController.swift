//
//  ViewController.swift
//  OpenAITest
//
//  Created by Igor Shefer on 16.12.22.
//

import UIKit

class imageDalleAiGeneratorViewController: UIViewController {
    @IBOutlet weak var generatedImageView: UIImageView!
    @IBOutlet weak var wordsDescriptionTextField: UITextField!
    
    let imageGenerator = ImageGeneratorManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didClickedOnGenerateImage(_ sender: UIButton) {
        Task {
            let obtainedImage = await imageGenerator.generateImage(withWords: wordsDescriptionTextField.text!)
            generatedImageView.image = obtainedImage
        }
    }
}

