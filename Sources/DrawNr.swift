//
//  DrawNr.swift
//  Ulam
//
//  Created by Stephan Jancar on 21.04.19.
//  Copyright © 2019 Ulam. All rights reserved.
//

#if false

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import Cocoa
#endif

protocol EmitImage {
    func Emit(image :UIImage )
}

//protocol ImageWorker {
//    func StartImageWorker(rect : CGRect)
//    func CreateImageDrawer(nr : UInt64, tester : NumTester?,worker : DispatchWorkItem?) -> ImageNrDrawer?
//    func StartImageShow(image : UIImage?)
//}

class DrawNrView : UIView, EmitImage, ImageWorker {
    internal var needredraw : Bool = true {
        didSet {
            workItem?.cancel()
            workItem = nil
        }
    }
    internal var workItem : DispatchWorkItem? = nil
    var nr : BigUInt = 1 {
        didSet {
            if nr != oldValue {    needredraw = true }
        }
    }
    var nr64 : UInt64 {
        if self.nr.isInt64() {
            return UInt64(self.nr)
        }
        return 1
    }
    var tester : NumTester? = nil {
        didSet {
            if tester?.property() != oldValue?.property() { needredraw = true }
        }
    }
    override var isHidden: Bool {
        willSet {
            assert(false)
            if newValue == false && isHidden == true {
                self.setNeedsDisplay()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //drself.isHidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        if isHidden { return }
        if !needredraw { return }
        needredraw = false
        workItem?.cancel()
        super.draw(rect)
        StartImageWorker(rect:rect)
    }
    
    func StartImageWorker(rect : CGRect) {
        return
    }
    func CreateImageDrawer(nr : UInt64, tester : NumTester?,worker : DispatchWorkItem?) -> ImageNrDrawer? {
        return nil
    }
    func StartImageShow(image : UIImage?) {
        return
    }
    func Emit(image: UIImage) {
        return
    }
    
}

class DrawNrImageView : DrawNrView {
    
    lazy var imageview : UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = self.backgroundColor
        imageview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageview)
        imageview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tapGestureRecognizer)
        return imageview
    }()
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if !imageview.isAnimating {
            imageview.startAnimating()
        }
        else {
            imageview.stopAnimating()
        }
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Some Default Implementations
    override func StartImageWorker(rect : CGRect) {
        self.imageview.animationImages = []
        self.workItem = DispatchWorkItem {
            guard let worker = self.workItem else { return }
            guard let drawer = self.CreateImageDrawer(nr: self.nr64, tester: self.tester, worker: worker) else { return }
            guard let image = drawer.DrawNrImage(rect: rect) else { return }
            if !worker.isCancelled {
                self.workItem = nil
                DispatchQueue.main.async(execute: {
                    self.StartImageShow(image: image)
                })
            }
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: self.workItem!)
    }
    
    override func StartImageShow(image: UIImage?) {
        imageview.image = image
        let customizeanimationDuration = 92.0
        imageview.animationDuration = 5.0 //92.0
        imageview.animationRepeatCount = 1
        imageview.startAnimating()
    }
    override func Emit(image: UIImage) {
        DispatchQueue.main.async(execute: {
            self.imageview.image  = image
            self.imageview.animationImages?.append(image)
            //self.imageview.startAnimating()
        })
    }
}

class ImageNrDrawer {
    var nr : UInt64
    var tester : NumTester? = nil
    var emitter : EmitImage?
    var worker : DispatchWorkItem?
    var rect = CGRect.zero
    init(nr : UInt64, tester : NumTester?, emitter : EmitImage?, worker: DispatchWorkItem?) {
        self.nr = nr
        self.tester = tester
        self.worker = worker
        self.emitter = emitter
    }
    func DrawNrImage(rect : CGRect) -> UIImage? {
        self.rect = rect
        return nil
    }
}

#endif

