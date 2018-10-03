//
//  HomeVC.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/29/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import UIKit
import Lottie
import Speech

class HomeVC: UIViewController, UITextFieldDelegate, SFSpeechRecognizerDelegate {

    // MARK: - Outlet
    // Tabbar Outlets
    @IBOutlet weak var asistantView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    // TranslateView outlets
    @IBOutlet weak var translateView: UIView!
    @IBOutlet weak var txtTranslate: UITextField!
    @IBOutlet weak var viewSearchTranslate: UIImageView!
    @IBOutlet weak var btnRecordTranslate: UIButton!
    @IBOutlet weak var btnHuyTranslate: UIButton!
    @IBOutlet weak var viewHelperPadding2: UIView!
    
    @IBOutlet var viewRecording: UIView!
    
    
    
    @IBOutlet weak var containerView: UIView!
    // MARK: - Vars
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var animationView : LOTAnimationView?
    
    var pageView : HomePageVC?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        pageView = self.childViewControllers[0] as? HomePageVC;
         initTabbar()
        initRecording()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI
    
    func initUI() {
        initTranslateView()
    }

    // MARK: - Tabar
    // controlling assistant view
    func createAssistant() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.touchOnAssistant))
        asistantView.addGestureRecognizer(gesture)

        animationView = LOTAnimationView(name: Constants.LOTTIE_EMOJI_WINK)
        animationView?.frame.size = CGSize(width: asistantView.frame.width , height: asistantView.frame.height)
        animationView?.frame.origin = CGPoint(x: 0 , y: 0)
        animationView?.contentMode = .scaleAspectFill
        asistantView.addSubview(animationView!)
//        animationView?.loopAnimation = true
    }
    
    @objc func touchOnAssistant(sender : UITapGestureRecognizer) {
        playAssistant()
    }

    func playAssistant() {
        animationView?.play()
    }
    func stopAssistant() {
        animationView?.stop()
    }

    // figure tabbar. Consist of setup, control buttons and views in tabbar.
    func initTabbar(){
        asistantView.layer.cornerRadius = asistantView.frame.height / 2
        asistantView.clipsToBounds = true
        asistantView.layer.borderWidth = 1
        asistantView.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        cameraActive(cameraBtn)
        
        createAssistant()
    }
    
    @IBAction func homeActive(_ sender: UIButton) {
        sender.setImage(UIImage(named: Constants.IC_HOME_ACTIVE), for: .normal)
        translateBtn.setImage(UIImage(named: Constants.IC_TRANSLATE), for: .normal)
        cameraBtn.setImage(UIImage(named: Constants.IC_CAMERA), for: .normal)
        favoriteBtn.setImage(UIImage(named: Constants.IC_FAVORITE), for: .normal)
        sender.nhayLonBe()
        pageView?.goHomeSubView()
    }
    
    @IBAction func translateActive(_ sender: UIButton) {
        sender.setImage(UIImage(named: Constants.IC_TRANSLATE_ACTIVE), for: .normal)
        homeBtn.setImage(UIImage(named: Constants.IC_HOME), for: .normal)
        cameraBtn.setImage(UIImage(named: Constants.IC_CAMERA), for: .normal)
        favoriteBtn.setImage(UIImage(named: Constants.IC_FAVORITE), for: .normal)
        sender.nhayLonBe()
        pageView?.goTranslateSubView()
    }
    
    @IBAction func cameraActive(_ sender: UIButton) {
        sender.setImage(UIImage(named: Constants.IC_CAMERA_ACTIVE), for: .normal)
        homeBtn.setImage(UIImage(named: Constants.IC_HOME), for: .normal)
        translateBtn.setImage(UIImage(named: Constants.IC_TRANSLATE), for: .normal)
        favoriteBtn.setImage(UIImage(named: Constants.IC_FAVORITE), for: .normal)
        sender.nhayLonBe()
        pageView?.goCameraSubView()
    }
    
    @IBAction func favoriteActive(_ sender: UIButton) {
        sender.setImage(UIImage(named: Constants.IC_FAVORITE_ACTIVE), for: .normal)
        homeBtn.setImage(UIImage(named: Constants.IC_HOME), for: .normal)
        translateBtn.setImage(UIImage(named: Constants.IC_TRANSLATE), for: .normal)
        cameraBtn.setImage(UIImage(named: Constants.IC_CAMERA), for: .normal)
        sender.nhayLonBe()
        pageView?.goFavoriteSubView()
    }
    
    // MARK: - Translate View on Top
    func initTranslateView() {
        self.txtTranslate.delegate = self
        txtTranslate.attributedPlaceholder = NSAttributedString(string: "Search in dictionary",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        translateView.layer.cornerRadius = translateView.frame.height / 2
        translateView.clipsToBounds = true
        
        self.btnHuyTranslate.isHidden = true
        
    }
    
    func didFocusTranslateTextField(isFocus: Bool) {
        UIView.animate(withDuration: 0.5) {
//            self.viewSearchTranslate.isHidden = isFocus ? true : false
            if isFocus{
                self.txtTranslate.becomeFirstResponder()
            }else{
                self.txtTranslate.resignFirstResponder()
            }
            self.btnHuyTranslate.isHidden = isFocus ? false : true
            self.viewHelperPadding2.isHidden = isFocus ? true : false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
            self.didFocusTranslateTextField(isFocus: false)
        
        //translate word
        TranslatorDevice.gotoDictionaryScreen(input: textField.text ?? "", inView: self)
        textField.text = ""
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
            self.didFocusTranslateTextField(isFocus: true)
    }
    
    @IBAction func cancelTranslateAction(_ sender: UIButton) {
          self.didFocusTranslateTextField(isFocus: false)
    }
    
    // MARK: - Recording View
    
    func initRecording()  {
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.setIsRecording(isRecord: !isButtonEnabled)
                if isButtonEnabled {
                    self.hideRecodingView()
                }else{
                    self.showRecodingView()
                }
            }
        }
    }
    // recording, when show and hide recoding View.
    @IBAction func startRecordAction(_ sender: Any) {
        setIsRecording(isRecord: true)
        showRecodingView()
        //start recording here.
        if !audioEngine.isRunning {
            self.txtTranslate.text = ""
            startRecording()
            print("Started recording...")
        }
    }
    
    func setIsRecording(isRecord : Bool) {
        txtTranslate.isUserInteractionEnabled = !isRecord
        btnRecordTranslate.isUserInteractionEnabled = !isRecord
        btnHuyTranslate.isUserInteractionEnabled = !isRecord
    }
    
    func showRecodingView() {
        
        viewRecording.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        viewRecording.alpha = 0.5
        containerView.addSubview(viewRecording)
        for subview in viewRecording.subviews{
            subview.removeFromSuperview()
        }
        
        let animationRecordingView = LOTAnimationView(name: "search")
        animationRecordingView.frame.size = CGSize(width: 200 , height: 200)
        animationRecordingView.contentMode = .scaleAspectFill
        animationRecordingView.center = viewRecording.center
        animationRecordingView.loopAnimation = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.touchToHideRecordingView))
        animationRecordingView.addGestureRecognizer(gesture)

        viewRecording.addSubview(animationRecordingView)
        
        animationRecordingView.play()
    }
    
    @objc func touchToHideRecordingView() {
        hideRecodingView()
        setIsRecording(isRecord: false)
        
        // stop recording here
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            //translate word
            TranslatorDevice.gotoDictionaryScreen(input: txtTranslate.text ?? "", inView: self)
            self.txtTranslate.text = ""
        }
        
    }
    
    func hideRecodingView() {
        viewRecording.removeFromSuperview()
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode as? AVAudioInputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                // show result
                self.txtTranslate.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.setIsRecording(isRecord: false)
                self.hideRecodingView()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        print("Say something, I'm listening!")
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            setIsRecording(isRecord: false)
            hideRecodingView()
        } else {
            setIsRecording(isRecord: true)
            showRecodingView()
        }
    }
    
    // MARK: - PageView
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
