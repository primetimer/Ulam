//
//  SequenceDrawer.swift
//  Ulam
//
//  Created by Stephan Jancar on 20.04.19.
//  Copyright © 2019 Ulam. All rights reserved.
//

/*
 
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif


public class SequenceDrawer  {
    var rect = CGRect.zero
    var bgcolor: Color? = nil
    var Direction : Int = 1
    private var context : CGContext!
    let count = 100
    let ulammode =  UlamType.square //UlamType.fibonacci UlamType.linear //
        
    public func DrawNrImage(rect : CGRect) -> UIImage? {
        self.rect = rect
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if bgcolor != nil {
            bgcolor?.setFill()
            UIRectFill(rect)
        }
        
        self.context = context
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(1.0);
        context.beginPath()
        let spiral = CreateSpiralDrawer(rect)
        spiral.draw_spiral(context)
        DrawNumbers(spiralDrawer: spiral, since: 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    private func CreateSpiralDrawer(_ rect : CGRect) -> UlamDrawer {
        let drawer = UlamDrawer(pointcount: self.count, utype: self.ulammode)
        drawer.colored = false
        drawer.bprimesphere = false
        drawer.direction = self.Direction
        drawer.bprimesizing = false
        drawer.overscan = 1.0
        drawer.setZoom(1.0)
        drawer.SetWidth(rect)
        drawer.pstart = 0
        return drawer
    }
    
    private func DrawNumbers(spiralDrawer: UlamDrawer, since : Int)
    {
        guard let tester = tester else { return }
        let timeout = TimeOut()
        for k in since ..< count {
            if worker?.isCancelled ?? false {
                return
            }
            let j = k // count - 1 - k
            var nr = BigUInt(self.nr)
            if Direction < 0 {
                if j > self.nr { break}
                nr = nr - BigUInt(j)
            } else {
                nr = nr + BigUInt(j)
            }
            
            let special = TesterCache.shared.TestSpecial(tester: tester, n: nr, cancel: timeout) ?? false
            //let special = tester.TestSpecialSync(n: BigUInt(nr)) ?? false #
            if !special { continue }
            
            spiralDrawer.draw_number(context, ulamindex: j, p: UInt64(nr), color : UIColor.red)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
            emitter?.Emit(image: image)
        }
    }
}

 */

