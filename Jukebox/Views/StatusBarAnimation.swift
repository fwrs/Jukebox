//
//  StatusBarButton.swift
//  Jukebox
//
//  Created by Sasindu Jayasinghe on 31/10/21.
//

import Foundation
import AppKit

class StatusBarAnimation: NSView {
    
    // Invalidating Variables
    var menubarIsDarkAppearance: Bool {
        didSet {
            render()
            self.needsDisplay = true
        }
    }
    
    var art: NSImage? {
        didSet {
            render()
            self.needsDisplay = true
        }
    }
    
    var isPlaying: Bool {
        didSet {
            render()
            self.needsDisplay = true
        }
    }
    
    // Computed Properties
    private var backgroundColor: CGColor {
        (menubarIsDarkAppearance || art != nil) ? NSColor.white.cgColor : NSColor.black.cgColor
    }
    
    // Properties
    private var bars = [CALayer]()
    private var artLayer: CALayer?
    private var artBackgroundLayer: CALayer?
    private var menubarHeight: Double
    
    // Overrides
    override var wantsUpdateLayer: Bool {
        return true
    }
    
    init(menubarAppearance: NSAppearance, menubarHeight: Double, art: NSImage?, isPlaying: Bool) {
        self.menubarIsDarkAppearance = menubarAppearance.name == .vibrantDark ? true : false
        self.art = art
        self.isPlaying = isPlaying
        self.menubarHeight = menubarHeight
        super.init(frame: CGRect(
            x: Constants.StatusBar.statusBarButtonPadding,
            y: 0,
            width: Constants.StatusBar.barAnimationWidth,
            height: menubarHeight))
        self.wantsLayer = true
        
        render()
    }
    
    func render() {
        self.layer?.sublayers?.removeAll()
        bars.removeAll()
        artLayer = nil
        
        if let art {
            let artBackgroundLayer = CALayer()
            artBackgroundLayer.frame = CGRect(x: 0, y: (menubarHeight / 2) - 8, width: 16.0, height: 16.0)
            artBackgroundLayer.cornerRadius = 2
            artBackgroundLayer.cornerCurve = .continuous
            artBackgroundLayer.masksToBounds = true
            artBackgroundLayer.backgroundColor = NSColor.gray.cgColor
            artBackgroundLayer.opacity = 0.5
            self.layer?.addSublayer(artBackgroundLayer)
            self.artBackgroundLayer = artBackgroundLayer

            let artLayer = CALayer()
            artLayer.contents = art.cgImage(forProposedRect: nil, context: nil, hints: nil)
            artLayer.frame = CGRect(x: 0, y: (menubarHeight / 2) - 8, width: 16.0, height: 16.0)
            artLayer.cornerRadius = 2
            artLayer.cornerCurve = .continuous
            artLayer.masksToBounds = true
            artLayer.magnificationFilter = .trilinear
            artLayer.minificationFilter = .trilinear
            self.layer?.addSublayer(artLayer)
            self.artLayer = artLayer
        }
        
        if !isPlaying {
            artBackgroundLayer?.opacity = 1
            artLayer?.opacity = 0.35
            
            for i in 0..<2 {
                let bar = CALayer()
                bar.backgroundColor = backgroundColor
                bar.cornerRadius = 1.5
                bar.cornerCurve = .continuous
                bar.anchorPoint = .zero
                if art == nil {
                    bar.frame = CGRect(x: 5.5 + Double(i) * 7, y: (menubarHeight / 2) - 6, width: 3, height: 12.0)
                } else {
                    bar.frame = CGRect(x: 4 + Double(i) * 5.5, y: (menubarHeight / 2) - 5, width: 2.5, height: 10.0)
                }
                self.layer?.addSublayer(bar)
                
                bars.append(bar)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayer() {
        for bar in bars {
            bar.backgroundColor = backgroundColor
        }
    }
    
}
