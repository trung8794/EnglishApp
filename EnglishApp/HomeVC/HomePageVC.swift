//
//  HomePageVC.swift
//  EnglishApp
//
//  Created by Nguyen Van Trung on 9/29/18.
//  Copyright © 2018 Nguyen Van Trung. All rights reserved.
//

import UIKit

class HomePageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var listControllerView = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "CameraVC")
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "TranslateVC")
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "HomeSubVC")
        let vc4 = self.storyboard?.instantiateViewController(withIdentifier: "FavoriteVC")
        listControllerView.append(vc1!)
        listControllerView.append(vc2!)
        listControllerView.append(vc3!)
        listControllerView.append(vc4!)
        
        setViewControllers([listControllerView[0]], direction: .reverse, animated: false, completion: nil)
        self.delegate = self
        self.dataSource = self
        
        for view in self.view.subviews {
            if let view = view as? UIScrollView   {
                view.isScrollEnabled = false
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = listControllerView.index(of: viewController), index > 0{
            return listControllerView[index - 1]
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = listControllerView.index(of: viewController), index < listControllerView.count - 1 {
            return listControllerView[index + 1]
        }
        return nil
    }
    
    func goHomeSubView() {
        setViewControllers([listControllerView[2]], direction: .forward, animated: false, completion: nil)
    }
    
    func goTranslateSubView() {
        setViewControllers([listControllerView[1]], direction: .forward, animated: false, completion: nil)
    }
    
    func goCameraSubView() {
        setViewControllers([listControllerView[0]], direction: .forward, animated: false, completion: nil)
    }
    
    func goFavoriteSubView() {
        setViewControllers([listControllerView[3]], direction: .forward, animated: false, completion: nil)
    }

}
