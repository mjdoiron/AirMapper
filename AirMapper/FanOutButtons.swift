//
//  FanOutButtons.swift
//  AirMapper
//
//  Created by Work on 4/30/17.
//  Copyright © 2017 Work. All rights reserved.
//

import Foundation

func fan(buttons: [UIButton], from originButton: UIButton, withRadius radius: CGFloat) {
    let totalPoints = buttons.count+1
    let angleSpaced = CGFloat(180/totalPoints)
    
    for index in 0...totalPoints {
        guard index != 0 else {
            continue
        }
        let angle = 180 - (angleSpaced * CGFloat(index) + 90)
        let x = cos(angle) * radius + originButton.frame.width
        let y = sin(angle) * radius
        
        if index <= buttons.count {
            let button = buttons[buttons.count-index]
            button.alpha = 1
            button.frame = originButton.frame.offsetBy(dx: x, dy: y)
        }
    }
}


func toggleBButtons() {
    if !bButtonExpanded {
        for button in self.buttons {
            button.alpha = 0
            button.frame = self.bButton.frame
        }
        UIView.animate(withDuration: 0.5) {
            self.fan(buttons: self.buttons, from: self.bButton, withRadius: CGFloat(66))
        }
        bButtonExpanded = true
    } else {
        UIView.animate(withDuration: 0.5) {
            for button in self.buttons {
                button.alpha = 0
                button.frame = self.bButton.frame
            }
        }
        bButtonExpanded = false
    }
}
