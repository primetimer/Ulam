//
//  ViewController.swift
//  UlamDemo
//
//  Created by Stephan Jancar on 28.04.19.
//  Copyright © 2019 Ulam. All rights reserved.
//

import UIKit
import Ulam

class UlamView : UIView, UlamDrawProtocol {
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
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(2.0)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.move(to: CGPoint(x:0, y: 0))
        context.addLine(to: CGPoint(x: 200, y: 300))
        context.strokePath()
        
        drawer.bdrawspiral = true
        drawer.colored = true
        //drawer.bprimesphere = true
        drawer.SetWidth(rect)
        drawer.draw_spiral(context)
        
        drawer.DrawSpiral(context)
        
        
        print("in DrawOnView")
    }
}
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w = min(view.frame.width,view.frame.height)
        let rect = CGRect(x: view.frame.minX, y: view.frame.minY,width: w,height: w)
        let drawer = UlamDrawer(pointcount: 100, utype: .square)
        let uview = UlamView(frame: rect, drawer: drawer)
        view.backgroundColor = .white
        view.addSubview(uview)
        // Do any additional setup after loading the view.
        
        // drawer.draw_spiral(<#T##context: CGContext##CGContext#>)
        
        
        
    }
    
    
}

