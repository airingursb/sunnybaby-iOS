//
//  CustomGestureRecognizer.swift
//  sunshine
//
//  Created by Airing on 16/8/1.
//  Copyright © 2016年 Airing. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class LeftGestureRecognizer: UIGestureRecognizer {
    var beginX:CGFloat = 0
    var endX:CGFloat = 0
    
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        let myTouch = touches.first! as UITouch
        let myLocation = myTouch.locationInView(self.view)
        beginX = myLocation.x
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        let myTouch = touches.first! as UITouch
        let myLocation = myTouch.locationInView(self.view)
        
        endX = myLocation.x
        
        if (beginX - endX) > 150 {
            self.state = UIGestureRecognizerState.Ended
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.reset()
    }
}
