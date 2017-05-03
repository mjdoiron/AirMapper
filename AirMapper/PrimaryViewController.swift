//
//  PrimaryViewController.swift
//  AirMapper
//
//  Created by Work on 4/29/17.
//  Copyright © 2017 Work. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyDraw
import AVFoundation

protocol PrimaryViewControllerDelegate {
    func updateBrush(brushSize:Float)
    func clearFog()
     func setMapImage(with: UIImage)
}

class PrimaryViewController: UIPageViewController {
    
    var pages:[UIViewController] = []
    var map:UIImageView!
    var scrollView:MapScrollView!
    var drawView:SwiftyDrawView!
    
    var settingsButton:UIButton!
    var undoButton:UIButton!
    var pushButton:UIButton!
    
    
    var secondaryViewController:SecondaryViewController?
    var hasNewMapToPush: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        
        let defaultMap = #imageLiteral(resourceName: "testMap")
        addNewPage(with: defaultMap)
        setupSecondScreen()
        registerForSreenNotifications()
        
        func click(sender: UIButton) {
            print("click")
        }
    }
    
    func addNewPage(with map: UIImage) {
        let VC = UIViewController()
        VC.view.frame = UIScreen.main.bounds
        
        let newMap = UIImageView(image: map)
        newMap.contentMode = .scaleAspectFit
        
        let newDrawView = SwiftyDrawView(frame: newMap.frame)
        if drawView == nil {
            newDrawView.delegate = self
            newDrawView.lineColor = .red
            newDrawView.lineWidth = 50
            newDrawView.alpha = 0.5
        } else {
            newDrawView.delegate = self
            newDrawView.lineColor = drawView.lineColor
            newDrawView.lineWidth = drawView.lineWidth
            newDrawView.alpha = drawView.alpha
        }
        
        let newScrollView = MapScrollView(frame: VC.view.bounds)
        newScrollView.backgroundColor = UIColor.black
        newScrollView.contentSize = newMap.bounds.size
        newScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newScrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        newScrollView.configureMapScrollView(map: newMap, drawView: newDrawView)
        newScrollView.delegate = self
        VC.view.addSubview(newScrollView)
        
        let newSettingsButton = UIButton()
        newSettingsButton.setImage(#imageLiteral(resourceName: "settingsWhite"), for: .normal)
        let newUndoButton = UIButton()
        newUndoButton.setImage(#imageLiteral(resourceName: "undoWhite"), for: .normal)
        let newPushButton = UIButton()
        newPushButton.setImage(#imageLiteral(resourceName: "airMapperLogoFilledWhite"), for: .normal)
        
        newSettingsButton.addTarget(self, action: #selector(PrimaryViewController.settingsButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        newUndoButton.addTarget(self, action: #selector(PrimaryViewController.undoButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        newPushButton.addTarget(self, action: #selector(PrimaryViewController.pushButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let buttons = [newSettingsButton, newUndoButton, newPushButton]
        for button in buttons {
            button.bounds.size = CGSize(width: 50, height: 50)
            button.alpha = 0.4
            button.contentMode = .scaleAspectFit
        }
        let buttonsStackView  = UIStackView(arrangedSubviews: buttons)
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.backgroundColor = .purple
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        VC.view.addSubview(buttonsStackView)
        
        let widthConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 55)
        
        let heightConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .height, relatedBy: .equal,
                                                  toItem: VC.view, attribute: .height, multiplier: 0.8, constant: 0)
        
        let xConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .left, relatedBy: .equal,
                                             toItem: VC.view, attribute: .left, multiplier: 1, constant: 20)
        
        let yConstraint = NSLayoutConstraint(item: buttonsStackView, attribute: .centerY, relatedBy: .equal,
                                             toItem: VC.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        let settingsButtonHeightConstraint = NSLayoutConstraint(item: newSettingsButton, attribute: .height, relatedBy: .equal,
                                                  toItem: newSettingsButton, attribute: .width, multiplier: 1, constant: 0)
        
        let undoButtonHeightConstraint = NSLayoutConstraint(item: newUndoButton, attribute: .height, relatedBy: .equal,
                                                                toItem: newUndoButton, attribute: .width, multiplier: 1, constant: 0)
        
        let pushButtonHeightConstraint = NSLayoutConstraint(item: newPushButton, attribute: .height, relatedBy: .equal,
                                                                toItem: newPushButton, attribute: .width, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint, settingsButtonHeightConstraint, undoButtonHeightConstraint, pushButtonHeightConstraint])

        
        pages += [VC]
        if pages.count == 1 {
            setViewControllers([pages.last!], direction: .forward, animated: true) { _ in
                self.map = newMap
                self.drawView = newDrawView
                self.scrollView = newScrollView
                self.settingsButton = newSettingsButton
                self.undoButton = newUndoButton
                self.pushButton = newPushButton
            }
        } else {
            setViewControllers([pages.last!], direction: .forward, animated: true) { _ in
                self.map = newMap
                self.drawView = newDrawView
                self.scrollView = newScrollView
                self.settingsButton = newSettingsButton
                self.undoButton = newUndoButton
                self.pushButton = newPushButton
            }
        }
    }
    
    func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowSideMenu", sender: self)
    }
    
    func undoButtonPressed(_ sender: Any) {
        drawView.removeLastLine()
    }
    
    func pushButtonPressed(_ sender: Any) {
        
        if UIScreen.screens.count == 1 || secondaryViewController == nil {
            let alert = UIAlertController(title: "No External Display", message: "Connect via Airplay or AV Cable", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
        
            let imageViewToPush = createCopyOfCurrentMapWithFog()
            
            if imageViewToPush.frame.size.height > imageViewToPush.frame.size.width {
                imageViewToPush.transform = imageViewToPush.transform.rotated(by:CGFloat.pi/2)
            }
            
            if hasNewMapToPush {
                secondaryViewController!.addNewMapViewController(with: imageViewToPush, hasFog: true)
                
                hasNewMapToPush = false
            } else {
                secondaryViewController!.pushMapUpdate(with: imageViewToPush)
            }
        }
    }
    
    func createCopyOfCurrentMapWithFog() -> UIImageView {
        let copyOfMap = UIImageView(frame: map.bounds)
        copyOfMap.image = map.image
        let copyOfDrawView = drawView.copySwiftyDrawTable()
        
        copyOfMap.addSubview(copyOfDrawView)
        copyOfMap.mask = copyOfDrawView
        
        let copyOfCurrentMapWithFog = UIImageView(frame: copyOfMap.bounds)
        copyOfCurrentMapWithFog.image = UIImage(view: copyOfMap)
        copyOfCurrentMapWithFog.contentMode = .scaleAspectFit
        
        return copyOfCurrentMapWithFog

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSideMenu" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! SideMenuViewController
            targetController.delegate = self
            targetController.brushSize = drawView.lineWidth
        }
    }

    func setupSecondScreen() {
        print("Screens @ setupSecondScreen: \(UIScreen.screens.count)")
        if UIScreen.screens.count > 1 {
            let secondScreen = UIScreen.screens[1]
            
            secondaryViewController = SecondaryViewController()
            secondaryViewController!.secondScreen = secondScreen
            secondaryViewController!.configureDefaultView()
            
        }
    }
    
    func registerForSreenNotifications(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(PrimaryViewController.setupSecondScreen), name: NSNotification.Name.UIScreenDidConnect, object: nil)
    }

}

extension PrimaryViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return map
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = map.bounds.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}

extension PrimaryViewController: SwiftyDrawViewDelegate {
    func SwiftyDrawDidBeginDrawing(view: SwiftyDrawView) {
        
        UIView.animate(withDuration: 0.5) {
            self.settingsButton.alpha = 0.0
            self.undoButton.alpha = 0.0
            self.pushButton.alpha = 0.0
        }
        
    }
    
    func SwiftyDrawIsDrawing(view: SwiftyDrawView) {
        
        // Called when the SwiftyDrawView detects touches are currrently occuring.
        // Will be called multiple times.
        
    }
    
    func SwiftyDrawDidFinishDrawing(view: SwiftyDrawView) {
        
        UIView.animate(withDuration: 0.3) {
            self.settingsButton.alpha = 0.4
            self.undoButton.alpha = 0.4
            self.pushButton.alpha = 0.4
        }
        
    }
    
    func SwiftyDrawDidCancelDrawing(view: SwiftyDrawView) {
        
        UIView.animate(withDuration: 0.3) {
            self.settingsButton.alpha = 0.4
            self.undoButton.alpha = 0.4
            self.pushButton.alpha = 0.4
        }
    }
}

extension PrimaryViewController: PrimaryViewControllerDelegate {
    func updateBrush(brushSize:Float) {
        drawView.lineWidth = CGFloat(brushSize)
    }
    
    func clearFog() {
        drawView.clearCanvas()
    }
    
    func setMapImage(with image: UIImage) {
        hasNewMapToPush = true
        addNewPage(with: image)
    }
}
