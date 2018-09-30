//
//  HomeSubVC.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/30/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import UIKit
import AVKit
import Vision

class HomeSubVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Life Circle
    private let session = AVCaptureSession()
    var deviceInput : AVCaptureDeviceInput!
    var videoDataOutput : AVCaptureVideoDataOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initCamera()
      
    }
    
    // MARK: - Init UI
//    func initCamera() {
//        let captureSession = AVCaptureSession()
//        captureSession.sessionPreset = .photo
//
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
//        captureSession.addInput(input)
//
//        captureSession.startRunning()
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
//
//        // addOutPut for camera
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(dataOutput)
//    }
    
//    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Camera was able to capture : ", Date())
//
//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{ return }
//
//        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else { return }
//
//        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
//            print(finishedReq.results)
//
//            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
//            guard let firstObservation = results.first else { return }
//            print(firstObservation.identifier, firstObservation.confidence)
//
//        }
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
