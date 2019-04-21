//
//  UlamDrawer.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 16.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias Color = UIColor
#elseif os(OSX)
import Cocoa
public typealias Color = NSColor
#endif

public protocol UlamDrawProtocol {
    func getColor(_ n : Int) -> Color
}

public class UlamDrawer:  NSObject {
    
    public var scalex = CGFloat(1.0)
    public var scaley = CGFloat(1.0)
    private var _overscan : CGFloat = 1.0
    private var pointscale = CGFloat(0.75)
    
    public var overscan : CGFloat {
        set {
            pointscale = pointscale / _overscan
            _overscan = newValue
            pointscale = pointscale * overscan
        }
        get { return _overscan }
    }
    
    private let pi = Double.pi
    private let phi = Double(sqrt(5.0) + 1.0 ) / 2.0
    
    fileprivate var size : CGFloat = 100.0
    public var count : Int = 1
    public var countbase : Int = 1
    
    public var bsemiprimes = false
    public var bprimesizing = false
    public var bprimesphere = false
    public var colored = false
    public var ptspiral : TheUlamBase? = nil
    public var rmax : Double =  1.0
    public var offset = 0
    public var bdrawspiral = false
    fileprivate var zoom : CGFloat = 1.0
    fileprivate var _pointwidth : CGFloat = 2.0
    fileprivate var pointwidth : CGFloat {
        set { _pointwidth = newValue }
        get { return max(_pointwidth,2.0) }
    }
    fileprivate var utype = UlamType.square
    fileprivate var _pstart : UInt64 = 2
    public var pstart : UInt64  {
        set {
            _pstart = newValue
        }
        get { return _pstart }
    }
    public var direction : Int = 1
    
    public var prot: UlamDrawProtocol? = nil
    
    public init (pointcount : Int, utype : UlamType, prot: UlamDrawProtocol? = nil) {
        super.init()
        self.prot = prot
        self.utype = utype
        count = max(pointcount,2)
        
        countbase = count
        
        switch utype {
        case .square:
            ptspiral = TheUlamRect.sharedInstance
        case .spiral:
            ptspiral = TheUlamRound.sharedInstance
        case .fibonacci:
            ptspiral = TheUlamFibonacci.sharedInstance
        case .hexagon:
            ptspiral = TheUlamHexagon.sharedInstance
        case .lucas:
            break
//            ptspiral = TheUlamLucas.sharedInstance
        case .linear:
            ptspiral = TheUlamLinear.sharedInstance
        }
    }
    
    private func getPointSize(_ p: Int) -> CGFloat {
        return pointwidth
    }
    
    public func setZoom(_ newzoom : CGFloat) //,  absolute : Bool = false)
    {
        zoom = zoom * newzoom
        count = Int(CGFloat(countbase) / zoom / zoom)
        pointwidth = size / sqrt(CGFloat(count)) * pointscale
        bdrawspiral = (count < 4000)
    }
    
    public func SetWidth(_ rect: CGRect) {
        let w = rect.size.width
        let h = rect.size.height
        size = min(w,h)
        if (w<h) {
            scaley = h / w
            scalex = 1.0
        } else {
            scalex = w / h
            scaley = 1.0
        }
        pointwidth = size / sqrt(CGFloat(count)) * pointscale
        rmax = ptspiral!.Radius(count)
    }
    
    public func getScreenXY(_ nr : Float) -> CGPoint {
        let spiral = getPoint(nr)
        let xp = CGFloat(spiral.x)
        let yp = CGFloat(spiral.y)
        let rm = rmax / Double(overscan)
        
        if (utype == .fibonacci)
        {
            var dtheta : Double = 2.0 * pi / phi / phi
            if direction < 0 { dtheta = -dtheta }
            let t = dtheta * (Double(pstart*1) + Double(nr*0.0))
            let t1 = floor(t / 2.0 / pi)
            let t2 = t / 2.0 / pi - t1
            let theta = CGFloat(t2 * 2.0 * pi)
            
            let xp1 = xp * cos(theta) - yp * sin(theta)
            let yp1 = yp * cos(theta) + xp * sin(theta)
            let x = (xp1+CGFloat(rm)) * size / CGFloat(2*rm)
            let y = (yp1+CGFloat(rm)) * size / CGFloat(2*rm)
            
            return CGPoint(x: CGFloat(x*scalex), y: CGFloat(y*scaley))
        }
        if (utype == .linear)
        {
            pointwidth = size / CGFloat(TheUlamLinear.sharedInstance.spokes)
            let xlin = xp / CGFloat( TheUlamLinear.sharedInstance.spokes) * size / 2.0
            let ylin = yp / CGFloat( TheUlamLinear.sharedInstance.spokes) * size
            return CGPoint(x: xlin, y: ylin)
        }
        
        
        let x = (xp+1.0*CGFloat(rm)) * size / CGFloat(2.0*rm)
        let y = (yp+1.0*CGFloat(rm)) * size / CGFloat(2.0*rm)
        return CGPoint(x: CGFloat(x*scalex), y: CGFloat(y*scaley))
    }
    
    public func prime_color(_ p : UInt64) -> CGColor {
        return Color.red.cgColor
    }
    
    fileprivate func getPoint(_ x : Float) -> SpiralXY {
        return ptspiral!.getPoint(Int(x))
    }
    
    public func draw_spiral(_ context : CGContext) -> Void {
        
        if count > TheUlamBase.defcount || colored  {
            bdrawspiral = false
        }
        if !bdrawspiral {
            return
        }
        
        if (utype == UlamType.fibonacci) {
            
            for j in 0...count-1  {
                
                let screenpt = getScreenXY(Float(j))
                switch j % 3
                {
                case 0:
                    let color = Color(red: 153.0 / 250.0, green: 101.0 / 255.0, blue: 21.0 / 255.0, alpha: 1.0)
                    //Color.blackColor()
                    color.setFill()
                case 1:
                    let color = Color.brown
                    color.setFill()
                default:
                    let color = Color.darkGray
                    color.setFill()
                }
                
                let xw = pointwidth * scalex / 3.0 * pointscale
                let yw = pointwidth * scaley / 3.0 * pointscale
                
                
                context.fill(CGRect(x: screenpt.x,y: screenpt.y,width: xw,height: yw));
            }
            
            //CGContextAddPath(context, path.CGPath)
            context.strokePath()
            return
        }
        
        if count > 0 {
            for j in 1...count  {
                let screenpt = getScreenXY(Float(j))
                let screenprev = getScreenXY(Float(j-1))
                context.move(to: CGPoint(x: screenprev.x, y: screenprev.y))
                context.addLine(to: CGPoint(x: screenpt.x, y: screenpt.y))
                context.strokePath()
            }
        }
        context.strokePath()
    }
    
    
    private func drawSphere(_ context : CGContext, xy: CGPoint, p : Int, color: Color  )
    {
        let r = getPointSize(p)
        var startPoint = CGPoint()
        startPoint.x = xy.x - r * 0.5
        startPoint.y = xy.y - r * 0.5
        var endPoint = CGPoint()
        endPoint.x = startPoint.x - r * 0.0
        endPoint.y = startPoint.y - r * 0.0
        let startRadius: CGFloat = 0
        //let color = getColor(p)
        //if color == nil { return }
        let colors = [Color.white.cgColor,color.cgColor]
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorspace,colors: colors as CFArray, locations: locations)
        let endRadius : CGFloat = max(1.0,r )
        
        context.drawRadialGradient (gradient!, startCenter: xy,
                                    startRadius: startRadius, endCenter: endPoint, endRadius: endRadius,
                                    options: CGGradientDrawingOptions(rawValue: 0))
    }
    
    private func drawRect(_ context : CGContext, xy: CGPoint, p : Int , color : Color)
    {
        let r = getPointSize(p)
        var startPoint = CGPoint()
        startPoint.x = xy.x - r * 0.125
        startPoint.y = xy.y - r * 0.125
        //let color = getColor(p)
        //if color == nil { return }
        let rect = CGRect(x: startPoint.x,y: startPoint.y ,width: r * scalex , height: r)
        
        color.setFill()
        context.fill(rect)
        if count < 200 && p <= 999  {
            let textcolor = Color.white
            textcolor.setStroke()
            let text = String(p)
            text.draw(in: rect, withAttributes: nil)
        }
    }
    
    public func DrawNumber(_ context : CGContext, ulamindex : Int, color : Color) {
        let screenpt = getScreenXY(Float(ulamindex))
        let xstart = screenpt.x - pointwidth * scalex * pointscale / 2.0
        let ystart = screenpt.y - pointwidth * scaley * pointscale / 2.0
        let xy = CGPoint(x: xstart, y: ystart)
        if bprimesphere {
            drawSphere(context,xy: xy, p: ulamindex, color : color)
        } else {
            drawRect(context, xy: xy, p: ulamindex, color: color)
        }
    }
    
    public func DrawSpiral(_ context: CGContext!, k0 : Int = 0, tlimit : CFTimeInterval = 5.0) -> Int
    {
        let starttime = CFAbsoluteTimeGetCurrent()
        let kstart = k0
        for k in kstart..<count
        {
            let deltatime = CFAbsoluteTimeGetCurrent() - starttime
            if (tlimit>0) && (deltatime > tlimit) { return k }
            let j = count - 1 - k
            if (direction < 0) && (pstart <=  UInt64(j+1))  { continue }
            //let nr : UInt64 = UInt64( Int (pstart) + j * direction)
            let p = Int(pstart) + j * direction
            if let prot = self.prot  {
                let color = prot.getColor(p)
                if colored {
                    DrawNumber(context, ulamindex: j, color : color)
                    continue
                }
                //            if p.isPrime
                do {
                    DrawNumber(context, ulamindex: j, color : color)
                    continue
                }
            }
        }
        return 0
    }
}

