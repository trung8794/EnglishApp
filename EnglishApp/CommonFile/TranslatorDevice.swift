//
//  TranslatorDevice.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 10/2/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import AVFoundation
import UIKit

class TranslatorDevice {
    static func speakeEnglish(input textInput : String){
        let voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        var voiceToUse: AVSpeechSynthesisVoice?
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if #available(iOS 9.0, *) {
                if voice.name == "Samantha" {
                    voiceToUse = voice
                }
            }
        }
        
        let utterance = AVSpeechUtterance(string: textInput)
        utterance.voice = voiceToUse
        let synth = AVSpeechSynthesizer()
        guard synth.isSpeaking else
        {
            synth.speak(utterance)
            return
        }
    }
    
    static func gotoDictionaryScreen(input textInput : String, inView view: UIViewController){
        if (textInput).isEmpty {
            return
        }
        let input = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: input) {
            let referenceVC = UIReferenceLibraryViewController(term: input)
            view.present(referenceVC, animated: true)
        }else{
            print("This word is not exist in dictionary")
            //            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            //                return
            //            }
            //
            //            if UIApplication.shared.canOpenURL(settingsUrl) {
            //                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            //                    print("Settings opened: \(success)") // Prints true
            //                })
            //            }
        }
    }
}

