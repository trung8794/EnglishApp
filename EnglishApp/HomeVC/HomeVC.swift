//
//  HomeVC.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/29/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import UIKit
import Lottie

class HomeVC: UIViewController, UITextFieldDelegate {

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
    var animationView : LOTAnimationView?
    
    var pageView : HomePageVC?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        pageView = self.childViewControllers[0] as? HomePageVC;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initTabbar()
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
        homeActive(homeBtn)
        
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
            self.btnHuyTranslate.isHidden = isFocus ? false : true
            self.viewHelperPadding2.isHidden = isFocus ? true : false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
            self.didFocusTranslateTextField(isFocus: false)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
            self.didFocusTranslateTextField(isFocus: true)
    }
    
    @IBAction func cancelTranslateAction(_ sender: UIButton) {
        txtTranslate.resignFirstResponder()
          self.didFocusTranslateTextField(isFocus: false)
    }
    
    // MARK: - Recording View
    // recording, when show and hide recoding View.
    @IBAction func startRecordAction(_ sender: Any) {
        setIsRecording(isRecord: true)
        showRecodingView()
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
        
        var animationRecordingView = LOTAnimationView(name: "search")
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
    }
    
    
    func hideRecodingView() {
        viewRecording.removeFromSuperview()
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
