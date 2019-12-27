//
//  ExtraCode.swift
//  CongressAppChallenge
//
//  Created by Emmett Shaughnessy on 10/16/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import Firebase

var UName:String?
var UserID:String?
var UserIsLoggedIn:Bool?


struct Items {
    
    var ItemName:String?
    
}

protocol DocumentSerializable {
    init? (dictionary:[String : Any])
}

struct ReminderLists {
    var listName:String?
    
    var dictionary:[String : Any] {
        return [
            "listName":listName!
        ]
        
    }
    
}

extension ReminderLists: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let listName = dictionary["listName"] as? String else {
            print("Item Not String")
            return nil}
        
        ReminderLists.init(listName: listName)
        
    }
}





struct lists {
    
    var listNames:String?
    
}







////For Gradient Backgrounds
//@IBDesignable class LDGradientView: UIView {
//
//    // the gradient layer
//    private var gradient: CAGradientLayer?
//
//    // create gradient layer
//    private func createGradient() -> CAGradientLayer {
//        let gradient = CAGradientLayer()
//        gradient.frame = self.bounds
//        return gradient
//    }
//
//    // Create a gradient and install it on the layer
//    private func installGradient() {
//        if let gradient = self.gradient {    gradient.removeFromSuperlayer()  }
//
//        let gradient = createGradient()
//        self.layer.addSublayer(gradient)
//        self.gradient = gradient
//    }
//
//    override var frame: CGRect {  didSet {    updateGradient()  }}
//    override func layoutSubviews() {  super.layoutSubviews()
//        updateGradient()
//    }
//
//    // Update an existing gradient
//    private func updateGradient() {
//        if let gradient = self.gradient {
//            let startColor = self.startColor ?? UIColor.clear
//            let endColor = self.endColor ?? UIColor.clear
//            gradient.colors = [startColor.cgColor, endColor.cgColor]
//            let (start, end) = gradientPointsForAngle(self.angle)
//            gradient.startPoint = start
//            gradient.endPoint = end
//            gradient.frame = self.bounds
//            }
//
//    }
//
//
//    // initializers required
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        installGradient()
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        installGradient()
//    }
//
//    var colors: [Any]?
//
//    // the gradient start colour
//    @IBInspectable var startColor: UIColor?
//    // the gradient end colour
//    @IBInspectable var endColor: UIColor?
//
//    // The end point of the gradient when drawn in the layer’s coordinate space. Animatable.
//    var endPoint: CGPoint
//    // The start point of the gradient when drawn in the layer’s coordinate space. Animatable.
//    var startPoint: CGPoint
//
//    // the gradient angle, in degrees anticlockwise from 0 (east/right)
//    @IBInspectable var angle: CGFloat = 270
//    // create vector pointing in direction of angle
//    private func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
//        let end = pointForAngle(angle)
//        let start = oppositePoint(end)
//        let p0 = transformToGradientSpace(start)
//        let p1 = transformToGradientSpace(end)
//        return (p0, p1)
//
//    }
//    private func pointForAngle(_ angle: CGFloat) -> CGPoint {
//        let radians = angle * .pi / 180.0
//        var x = cos(radians)
//        var y = sin(radians)
//        if (abs(x) > abs(y)) {
//            x = x > 0 ? 1 : -1
//            y = x * tan(radians)
//
//        } else {
//            y = y > 0 ? 1 : -1
//            x = y / tan(radians)
//
//        }
//        return CGPoint(x: x, y: y)
//
//    }
//
//
//    private func oppositePoint(_ point: CGPoint) -> CGPoint {  return CGPoint(x: -point.x, y: -point.y) }
//
//    private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
//        return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
//    }
//
//
//
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        installGradient()
//        updateGradient()
//    }
//
//
//}


