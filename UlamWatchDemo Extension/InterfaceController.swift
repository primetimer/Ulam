//
//  InterfaceController.swift
//  UlamWatchDemo Extension
//
//  Created by Stephan Jancar on 28.04.19.
//  Copyright © 2019 Ulam. All rights reserved.
//

import WatchKit
import Foundation
import Ulam

class InterfaceController: WKInterfaceController , UlamDrawProtocol {
    func getColor(_ n: Int) -> Color {
        return Color.red
    }
    
    
    private func Draw(rect : CGRect) -> UIImage? {

        let size = rect.size
        if rect.size == CGSize.zero {
            return nil
        }
        UIGraphicsBeginImageContext(size)
        guard  let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // Setup for the path appearance
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(1.0)
        
        // Draw lines
//        context!.beginPath()
//        context!.move(to: CGPoint(x: 0, y: 0))
//        context!.strokePath()

        let drawer = UlamDrawer(pointcount: 100, utype: .fibonacci, prot: self)
        
        drawer.bdrawspiral = true
        drawer.colored = true
        drawer.bprimesphere = true
        drawer.SetWidth(rect)
        drawer.draw_spiral(context)
        
        drawer.DrawSpiral(context)

        let cgimage = context.makeImage()!
        let uiimage = UIImage(cgImage: cgimage)

        return uiimage
     }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    @IBOutlet weak var uiUlam: WKInterfaceImage!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
// let rect = self.contentFrame
        let rect = CGRect(x: 0.0, y: 0.0, width: contentFrame.width, height: contentFrame.width)
        print("Rect: \(rect)")
        let image  = Draw(rect: rect)
        uiUlam.setImage(image)
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
