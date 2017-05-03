//
//  MapScrollView.swift
//  AirMapper
//
//  Created by Work on 4/30/17.
//  Copyright © 2017 Work. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDraw

class MapScrollView: UIScrollView {
    
    var map:UIImageView!
    var drawView:SwiftyDrawView!
    
    func configureMapScrollView(map: UIImageView, drawView: SwiftyDrawView){
        self.map = map
        self.drawView = drawView
        
        self.map.addSubview(self.drawView)
        self.addSubview(map)
        setZoomScale()
    }
    
    func setZoomScale() {
        let imageViewSize = map.bounds.size
        let scrollViewSize = self.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        minimumZoomScale = min(widthScale, heightScale)
        maximumZoomScale = 2
        zoomScale = 1.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            drawView.touchesBegan(touches, with: event)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.count == 1 {
            drawView.touchesMoved(touches, with: event)
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            drawView.touchesEnded(touches, with: event)
        }
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touches.count == 1 {
            drawView.touchesCancelled(touches, with: event)
        }
        super.touchesCancelled(touches, with: event)
    }
}
