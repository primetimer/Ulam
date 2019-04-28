//
//  ViewController.swift
//  UlamDemoMc
//
//  Created by Stephan Jancar on 28.04.19.
//  Copyright © 2019 Ulam. All rights reserved.
//

import Cocoa
import Ulam

class UlamView : NSView, UlamDrawProtocol {
    func getColor(_ n: Int) -> Color {
        return .red
    }
    
    
    var drawer : UlamDrawer!
    init(frame: CGRect, drawer : UlamDrawer) {
        super.init(frame: frame)
        self.drawer = drawer
        drawer.prot = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let context = NSGraphicsContext.current else { return }
        context.cgContext.setLineWidth(2.0)
        context.cgContext.setStrokeColor(Color.blue.cgColor)
        context.cgContext.move(to: CGPoint(x:100, y: 100))
        context.cgContext.addLine(to: CGPoint(x: 200, y: 300))
        context.cgContext.strokePath()
        
        drawer.bdrawspiral = true
        drawer.colored = true
        //drawer.bprimesphere = true
        drawer.SetWidth(rect)
        drawer.draw_spiral(context.cgContext)
        
        drawer.DrawSpiral(context.cgContext)
        
        
        print("in DrawOnView")
    }
}

class ViewController: NSViewController {

    var ulamview: UlamView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let w = min(view.frame.width,view.frame.height)
        let rect = CGRect(x: view.frame.minX, y: view.frame.minY,width: w,height: w)
        let drawer = UlamDrawer(pointcount: 100, utype: .square)
        let uview = UlamView(frame: rect, drawer: drawer)
//        view.backgroundColor = .white
        view.addSubview(uview)
        
        

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

