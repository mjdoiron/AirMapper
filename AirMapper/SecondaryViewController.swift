//
//  SecondaryViewController.swift
//  AirMapper
//
//  Created by Work on 5/2/17.
//  Copyright © 2017 Work. All rights reserved.
//

import Foundation
import UIKit

class SecondaryViewController: UIPageViewController {
    
    var secondScreen:UIScreen!
    var secondWindow:UIWindow!
    var mapViewControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureDefaultView(){
        secondWindow = UIWindow(frame: secondScreen.bounds)
        secondWindow.isHidden = true
        secondWindow.rootViewController = self
        secondWindow.screen = secondScreen
        self.view.backgroundColor = .purple
        addNewMapViewController(with: nil, hasFog: false)
        let defaultView = mapViewControllers.first!.view
        let logo = UIImageView(image: UIImage(named: "airMapperLogoFilled"))
        logo.contentMode = .scaleAspectFit
        logo.frame = CGRect(origin: defaultView!.center, size: CGSize(width: defaultView!.frame.width/2, height: defaultView!.frame.height/2))
        logo.center = secondWindow!.center
        defaultView!.addSubview(logo)
        defaultView!.backgroundColor = .lightGray
        secondWindow.isHidden = false
    }
    
    func addNewMapViewController(with map:UIImageView?, hasFog:Bool) {
        let viewController = UIViewController()
        viewController.view.frame = secondWindow!.frame
        
        if hasFog {
            let fog = UIView(frame: secondWindow!.frame)
            fog.backgroundColor = .black
            viewController.view.addSubview(fog)
        }
        if map != nil {
            let newMap = map!
            newMap.frame = viewController.view.frame
            viewController.view.addSubview(map!)
        }
        mapViewControllers += [viewController]
        if mapViewControllers.count == 1 {
            setViewControllers(mapViewControllers, direction: .forward, animated: true)
        } else {
            setViewControllers([mapViewControllers.last!], direction: .forward, animated: true)
        }
        
//        if mapViewControllers.count > 1 {
//            mapViewControllers = Array(mapViewControllers.dropFirst(1))
//        }
    }
    
    func pushMapUpdate(with imageView:UIImageView) {
        print("mapViewControllers.count = \(mapViewControllers.count)")
        if mapViewControllers.count > 0 {
            let viewController = self.mapViewControllers.last!
            
            let fog = UIView(frame: secondWindow.frame)
            fog.backgroundColor = .black
            viewController.view.addSubview(fog)

            let newMap = imageView
            newMap.frame = fog.frame
            fog.addSubview(newMap)
            
            fog.alpha = 0
            viewController.view.addSubview(fog)
            UIView.animate(withDuration: 1) {
                let viewController = self.mapViewControllers.last!
                viewController.view.subviews.last!.alpha = 1
            }
            if viewController.view.subviews.count > 3 {
                let firstSubview = viewController.view.subviews[0]
                firstSubview.removeFromSuperview()
            }
        }
    }
}
