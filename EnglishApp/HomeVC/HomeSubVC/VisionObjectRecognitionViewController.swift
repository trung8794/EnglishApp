//
//  VisionObjectRecognitionViewController.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/30/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: HomeSubVC {
    
    // MARK: - Outlets
    @IBOutlet var viewShowObjectInfo: UIView!
    @IBOutlet weak var txtNameObject: UILabel!
    @IBOutlet weak var viewNameOfObject: UIView!
    @IBOutlet weak var btnDictionary: UIButton!
    @IBOutlet weak var btnSpeech: UIButton!
    
    
    
    // MARK: - Vars
    var detectionOverlay: CALayer! = nil
    var objectIdentify: String! = nil
    var infoView: UIView! = nil
    
    var textOutput = ""
    // Vision parts
    private var requests = [VNRequest]()
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        do {
            let visionModel = try VNCoreMLModel(for: Inceptionv3().model)
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                        
                    }
                })
            })
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        for observation in results where observation is VNClassificationObservation {
            guard observation is VNClassificationObservation else {
                continue
            }
            // Select only the label with the highest confidence.
            guard let topLabelObservation = results.first as? VNClassificationObservation else { return }
            let objectName = topLabelObservation.identifier
            if objectName != objectIdentify && topLabelObservation.confidence >= 0.3 {
                if (viewShowObjectInfo != nil) {
                    viewShowObjectInfo.removeFromSuperview()
                }
                
                print("\(topLabelObservation.identifier) - \(topLabelObservation.confidence)")
                objectIdentify = objectName
                
                var fullObjectArr = topLabelObservation.identifier.components(separatedBy: ",")
                let firstObj: String = fullObjectArr[0].trimmingCharacters(in: .whitespacesAndNewlines)
                txtNameObject.text = firstObj
                textOutput = firstObj
                
                self.view.addSubview(viewShowObjectInfo)
            }
            
        }
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func setupObjectInfomationView() {
        viewShowObjectInfo.frame = CGRect(x: 10, y: 100, width: rootLayer.frame.width - 20, height: 60)
        viewShowObjectInfo.layer.cornerRadius = 10
        viewShowObjectInfo.clipsToBounds = true
        btnDictionary.layer.cornerRadius = 10
        btnSpeech.layer.cornerRadius = 10
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        setupViews()
        super.setupAVCapture()
        
        // setup Vision parts
        setupLayers()
        updateLayerGeometry()
        setupVision()
        setupObjectInfomationView()
    }
    func setupViews() {
        btnSpeech.addEffect()
        btnDictionary.addEffect()
        btnSpeech.layer.cornerRadius = 5
        btnSpeech.clipsToBounds = true
        btnDictionary.layer.cornerRadius = 5
        btnDictionary.clipsToBounds = true
    }
    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        // center the layer
        detectionOverlay.position = CGPoint (x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
        
    }
    
    // MARK: - Actions Button
    @IBAction func goDictionaryScreen(_ sender: UIButton) {
        TranslatorDevice.gotoDictionaryScreen(input: textOutput, inView: self)
    }
    @IBAction func speechWord(_ sender: UIButton) {
        TranslatorDevice.speakeEnglish(input: textOutput)
    }
    
}
