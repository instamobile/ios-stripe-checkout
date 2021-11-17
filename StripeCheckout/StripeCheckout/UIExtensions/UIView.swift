//
//  UIView.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

extension UIView {

    func addVerticalGradient(colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0.0, 1.0]

        self.layer.insertSublayer(gradient, at: 0)
    }

    func dropCupertinoShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(hexString: "#333333").cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 7

//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1

        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        if let startPoint = startPoint, let endPoint = endPoint {
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.insertSublayer(gradient, at: 0)
    }

    public enum ViewSide {
        case top
        case right
        case bottom
        case left
    }

    public func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {

        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height), color: color)
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .left:
            // Right Has No Effect
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        }
    }

    public func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {

        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border

        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border

        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border

        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        }
    }

    public func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {

        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset,
                                                                   height: thickness), color: color)
            self.layer.addSublayer(border)
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                   y: 0 + topOffset, width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: self.frame.size.height-thickness-bottomOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset, height: thickness), color: color)
            self.layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        }
    }

    public func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {

        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)

        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)

        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        }
    }

    //////////
    // Private: Our methods call these to add their borders.
    //////////


    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }

    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
}
