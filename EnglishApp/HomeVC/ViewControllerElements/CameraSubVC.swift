//
//  CameraSubVC.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/30/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import UIKit

class CameraSubVC: UIViewController {
    // MARK : - Outlets
    @IBOutlet weak var btnOpenCamera: UIButton!
    

    // MARK : - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

        // Do any additional setup after loading the view.
    }
    
    // MARK : - Init UI
    func initUI() {
        btnOpenCamera.layer.cornerRadius = 10
        btnOpenCamera.clipsToBounds = true
        btnOpenCamera.addEffect()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK : - Button Actions
    
    @IBAction func openCameraAction(_ sender: UIButton) {
        print("Call outside extension")
    }
    
}
