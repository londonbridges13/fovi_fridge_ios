//
//  Popover.swift
//  Popover
//
//  Created by corin8823 on 8/16/15.
//  Copyright (c) 2015 corin8823. All rights reserved.
// 



// This code has been tweaked to work with swift 2.0, and more specifically your software so ... ENJOY, AND USE THIS

import UIKit

public enum PopoverOption {
    case ArrowSize(CGSize)
    case AnimationIn(NSTimeInterval)
    case AnimationOut(NSTimeInterval)
    case CornerRadius(CGFloat)
    case SideEdge(CGFloat)
    case BlackOverlayColor(UIColor)
    case Type(Popover.PopoverType)
}

public class Popover: UIView {
    
    public enum PopoverType {
        case Up
        case Down
    }
    
    // custom property
    private var arrowSize: CGSize = CGSize(width: 16.0, height: 10.0)
    private var animationIn: NSTimeInterval = 0.6
    private var animationOut: NSTimeInterval = 0.3
    private var cornerRadius: CGFloat = 6.0
    private var sideEdge: CGFloat = 20.0
    private var popoverType: PopoverType = .Down
    private var blackOverlayColor: UIColor = UIColor(white: 0.0, alpha: 0.2)
    
    // custom closure
    private var didShowHandler: (() -> ())?
    private var didDismissHandler: (() -> ())?
    
    private var blackOverlay: UIControl = UIControl()
    private var containerView: UIView!
    private var contentView: UIView!
    private var contentViewFrame: CGRect!
    private var arrowShowPoint: CGPoint!
    
    public init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
    }
    
    public init(options: [PopoverOption]?) {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.setOptions(options)
    }
    
    public init(showHandler: (() -> ())?, dismissHandler: (() -> ())?) {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.didShowHandler = showHandler
        self.didDismissHandler = dismissHandler
    }
    
    public init(options: [PopoverOption]?, showHandler: (() -> ())?, dismissHandler: (() -> ())?) {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.setOptions(options)
        self.didShowHandler = showHandler
        self.didDismissHandler = dismissHandler
    }
    
    private func setOptions(options: [PopoverOption]?){
        if let options = options {
            for option in options {
                switch option {
                case let .ArrowSize(value):
                    self.arrowSize = value
                case let .AnimationIn(value):
                    self.animationIn = value
                case let .AnimationOut(value):
                    self.animationOut = value
                case let .CornerRadius(value):
                    self.cornerRadius = value
                case let .SideEdge(value):
                    self.sideEdge = value
                case let .BlackOverlayColor(value):
                    self.blackOverlayColor = value
                case let .Type(value):
                    self.popoverType = value
                }
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.create()
    }
    
    private func create() {
        var frame = self.contentView.frame
        frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5
        
        var sideEdge: CGFloat = 0.0
        if frame.size.width < self.containerView.frame.size.width {
            sideEdge = self.sideEdge
        }
        
        let outerSideEdge = CGRectGetMaxX(frame) - self.containerView.bounds.size.width
        if outerSideEdge > 0 {
            frame.origin.x -= (outerSideEdge + sideEdge)
        } else {
            if CGRectGetMinX(frame) < 0 {
                frame.origin.x += abs(CGRectGetMinX(frame)) + sideEdge
            }
        }
        self.frame = frame
        
        let arrowPoint = self.containerView.convertPoint(self.arrowShowPoint, toView: self)
        let anchorPoint: CGPoint
        switch self.popoverType {
        case .Up:
            frame.origin.y = self.arrowShowPoint.y - frame.height - self.arrowSize.height
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 1)
        case .Down:
            frame.origin.y = self.arrowShowPoint.y
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 0)
        }
        
        let lastAnchor = self.layer.anchorPoint
        self.layer.anchorPoint = anchorPoint
        let x = self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width
        let y = self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height
        self.layer.position = CGPoint(x: x, y: y)
        
        frame.size.height += self.arrowSize.height
        self.frame = frame
    }
    
    public func show(contentView: UIView, fromView: UIView) {
        let point: CGPoint
        switch self.popoverType {
        case .Up:
            point = CGPoint(x: fromView.frame.origin.x + (fromView.frame.size.width / 2), y: fromView.frame.origin.y)
        case .Down:
            point = CGPoint(x: fromView.frame.origin.x + (fromView.frame.size.width / 2), y: fromView.frame.origin.y + fromView.frame.size.height)
        }
        self.show(contentView, point: point, inView: fromView)
    }
    
    public func show(contentView: UIView, point: CGPoint, inView: UIView) {
//        let inView = UIApplication.sharedApplication().keyWindow!
        self.blackOverlay.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.blackOverlay.frame = inView.bounds
        self.blackOverlay.backgroundColor = self.blackOverlayColor
        inView.addSubview(self.blackOverlay)
        
        self.blackOverlay.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        self.containerView = inView
        self.contentView = contentView
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.layer.cornerRadius = self.cornerRadius
        self.contentView.layer.masksToBounds = true
        self.arrowShowPoint = point
        self.show()
    }
    
    private func show() {
        self.setNeedsDisplay()
        switch self.popoverType {
        case .Up:
            self.contentView.frame.origin.y = 0.0
        case .Down:
            self.contentView.frame.origin.y = self.arrowSize.height
        }
        self.addSubview(self.contentView)
        self.containerView.addSubview(self)
        
        self.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(self.animationIn, delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 3,
                                   options: .CurveEaseInOut,
                                   animations: {
                                    self.transform = CGAffineTransformIdentity
        }){ _ in
            self.didShowHandler?()
        }
    }
    
    public func dismiss() {
        if self.superview != nil {
            UIView.animateWithDuration(self.animationOut, delay: 0,
                                       options: .CurveEaseInOut,
                                       animations: {
                                        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            }){ _ in
                self.contentView.removeFromSuperview()
                self.blackOverlay.removeFromSuperview()
                self.removeFromSuperview()
                self.didDismissHandler?()
            }
        }
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let arrow = UIBezierPath()
        let color = UIColor.whiteColor()
        let arrowPoint = self.containerView.convertPoint(self.arrowShowPoint, toView: self)
        switch self.popoverType {
        case .Up:
            arrow.moveToPoint(CGPoint(x: arrowPoint.x, y: self.bounds.height))
            arrow.addLineToPoint(CGPoint(x: arrowPoint.x - self.arrowSize.width * 0.5, y: self.bounds.height - self.arrowSize.height))
            
            arrow.addLineToPoint(CGPoint(x: self.cornerRadius, y: self.bounds.height - self.arrowSize.height))
            arrow.addArcWithCenter(CGPoint(x: self.cornerRadius, y: self.bounds.height - self.arrowSize.height - self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(90),
                                   endAngle: self.radians(180),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: 0, y: self.cornerRadius))
            arrow.addArcWithCenter(CGPoint(x: self.cornerRadius, y: self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(180),
                                   endAngle: self.radians(270),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: self.bounds.width - self.cornerRadius, y: 0))
            arrow.addArcWithCenter(CGPoint(x: self.bounds.width - self.cornerRadius, y: self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(270),
                                   endAngle: self.radians(0),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height - self.arrowSize.height - self.cornerRadius))
            arrow.addArcWithCenter(CGPoint(x: self.bounds.width - self.cornerRadius, y: self.bounds.height - self.arrowSize.height - self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(0),
                                   endAngle: self.radians(90),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: arrowPoint.x + self.arrowSize.width * 0.5,
                y: self.bounds.height - self.arrowSize.height))
            
        case .Down:
            arrow.moveToPoint(CGPoint(x: arrowPoint.x, y: 0))
            arrow.addLineToPoint(CGPoint(x: arrowPoint.x + self.arrowSize.width * 0.5, y: self.arrowSize.height))
            
            arrow.addLineToPoint(CGPoint(x: self.bounds.width - self.cornerRadius, y: self.arrowSize.height))
            arrow.addArcWithCenter(CGPoint(x: self.bounds.width - self.cornerRadius, y: self.arrowSize.height + self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(270.0),
                                   endAngle: self.radians(0),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height - self.cornerRadius))
            arrow.addArcWithCenter(CGPoint(x: self.bounds.width - self.cornerRadius, y: self.bounds.height - self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(0),
                                   endAngle: self.radians(90),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: 0, y: self.bounds.height))
            arrow.addArcWithCenter(CGPoint(x: self.cornerRadius, y: self.bounds.height - self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(90),
                                   endAngle: self.radians(180),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: 0, y: self.arrowSize.height + self.cornerRadius))
            arrow.addArcWithCenter(CGPoint(x: self.cornerRadius, y: self.arrowSize.height + self.cornerRadius),
                                   radius: self.cornerRadius,
                                   startAngle: self.radians(180),
                                   endAngle: self.radians(270),
                                   clockwise: true)
            
            arrow.addLineToPoint(CGPoint(x: arrowPoint.x - self.arrowSize.width * 0.5,
                y: self.arrowSize.height))
        }
        
        color.setFill()
        arrow.fill()
    }
    
    private func radians(degrees: CGFloat) -> CGFloat {
        return (CGFloat(M_PI) * degrees / 180)
    }
}