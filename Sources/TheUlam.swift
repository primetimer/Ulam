//
//  TheUlam.swift
//  PrimeTime
//
//  Created by Stephan Jancar on 11.04.16.
//  Copyright © 2016 esjot. All rights reserved.
//

import Foundation

enum UlamType : Int {
    case square = 0, spiral = 1, fibonacci = 2, lucas = 3, hexagon = 4, linear = 5
}

#if false
let theulamrect = TheUlamRect()
let theulamspiral = TheUlamRound()
let theulamexplode = TheUlamFibonacci()
let theulamhexagon = TheUlamHexagon()
#endif

typealias SpiralXY = (x: Float, y: Float)

class TheUlamBase  {
    
    static let defcount = 3600 //##
    internal var count = defcount + 1
    //private var pt : [SpiralXY] = []
    
    func Radius(_ count : Int) -> Double
    {
        return ceil(sqrt(Double(count)))+1
    }
    
    func getPoint(_ n: Int) -> SpiralXY {
        assert(false) // Please Override
        let pt = (x: Float(0.0), y: Float(0.0))
        return pt
    }
}

class TheUlamRound : TheUlamBase {
    static let sharedInstance = TheUlamRound()
    
    let pi = Float(4.0 * atan(1.0))
    
    override func getPoint(_ n: Int) -> SpiralXY {
        let i = n + 1
        let r = sqrt(Float(i))
        let theta =  pi * r * 2.0
        let x = cos(theta)*r
        let y = -sin(theta)*r
        let p = (x: x, y: y)
        return p
    }
    
    
}

class TheUlamFibonacci : TheUlamBase {
    static let sharedInstance = TheUlamFibonacci()
    private var dtheta :  Double
    static let phi = (1.0 + sqrt(5.0)) / 2.0
    fileprivate override init() {
        self.dtheta =  2.0 * Double.pi / TheUlamFibonacci.phi / TheUlamFibonacci.phi
        super.init()
        
    }
    override func getPoint(_ n: Int) -> SpiralXY {
        let i = n
        let r = sqrt(Double(i))
        let theta =  Double(n) * dtheta
        let x = cos(theta)*r
        let y = -sin(theta)*r
        let p = (x: Float(x), y: Float(y))
        return p
    }
    
}

/*
class TheUlamLucas : TheUlamBase {
    static let sharedInstance = TheUlamLucas()
    private override init() {
        super.init()
    }
    override func getPoint(_ n: Int) -> SpiralXY {
        let i = n
        let r = sqrt(Double(i))
        let ln = LucasTester.Ln(n: n)
        let ln1 = LucasTester.Ln(n: n+1)
        let q = ln1 / ln
        let theta = 2.0 * Double.pi / q / q * Double(n)
        let x = cos(theta)*r
        let y = -sin(theta)*r
        let p = (x: Float(x), y: Float(y))
        return p
    }
    
}
 */

class TheUlamHexagon : TheUlamBase {
    static let sharedInstance = TheUlamFibonacci()
    
    fileprivate override init() {
        super.init()
    }
    
    override func getPoint(_ n: Int) -> SpiralXY {
        
        #if false
        if n == 0 { return (x: 0.0, y: 0.0) }
        let n3 = round(sqrt( Double(n) / 3.0 ))
        let layer = Int(n3)
        let firstIdxInLayer = 3*layer*(layer-1) + 1
        let side = (n - firstIdxInLayer) / layer; // note: this is integer division
        let idx  = (n - firstIdxInLayer) % layer;
        var xp =  Double(layer) * cos( Double(side - 1) * M_PI / 3.0)
        xp = xp + Double(idx + 1) * cos( Double(side + 1) * M_PI / 3.0 );
        var yp = -Double(layer) * sin( Double(side - 1) * M_PI / 3.0 )
        yp = yp - Double(idx + 1) * sin( Double(side + 1) * M_PI / 3.0 )
        let p = (x: Float(2*xp), y: Float(2*yp))
        return p
        #endif
        #if true //Sechseck
        let h : [Double] = [  1, 1, 0, -1, -1, 0, 1, 1, 0 ]
        if n == 0 { return (x: 0.0, y: 0.0) }
        let n3 = round(sqrt( Double(n) / 3.0 ))
        let layer = Int(n3)
        let firstIdxInLayer = 3*layer*(layer-1) + 1
        let side = (n - firstIdxInLayer) / layer; // note: this is integer division
        let idx  = (n - firstIdxInLayer) % layer;
        
        var hx = Double(layer)*h[side+0]
        hx = hx + Double(idx+1) * h[side+2]
        var hy = Double(layer)*h[side+1]
        hy = hy + Double(idx+1) * h[side+3]
        
        let xp = hx - hy * 0.5
        let yp = hy * sqrt(0.75)
        let p = (x: Float(1.5*xp), y: Float(1.5*yp))
        return p
        #endif
    }
    
}

class TheUlamRect : TheUlamBase {
    static let sharedInstance = TheUlamRect()
    
    
    
    override func getPoint(_ n : Int) -> SpiralXY
    {
        let w2 = sqrt(Double(n))
        let w = ( w2 + 1.0 ) / 2.0
        let m : Int = Int(floor(w))
        let k : Int = n - 4 * m * ( m - 1 )
        var x = 0
        var y = 0
        
        if k <= 2 * m {
            x = m
            y = k - m
        } else if  k <= 4*m  {
            x = 3 * m - k
            y = m
        } else if k <= 6*m {
            x = -m
            y = 5 * m - k
        } else if k <= 8*m {
            x = k - 7 * m
            y = -m
        }
        let p = (x: Float(2*x), y: Float(2*y))
        return p
    }
}

class TheUlamLinear : TheUlamBase {
    static let sharedInstance = TheUlamLinear()
    private (set) var spokes = 30
    
    override func Radius(_ count : Int) -> Double
    {
        let cd = ceil(sqrt(Double(count)))
        spokes = Int(cd)
        
        return Double(count) / Double(spokes) / 4.0
        //return ceil(sqrt(Double(count)))+1
    }
    
    override func getPoint(_ n : Int) -> SpiralXY
    {
        let m : Int = spokes
        let x = n % m
        let y = n / m
        let p = (x: Float(2*x+1), y: Float(y)+0.75)
        return p
    }
}






