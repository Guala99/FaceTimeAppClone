//
//  Extensions.swift
//  FaceTime Clone App
//
//  Created by Andrea Gualandris on 28/10/2021.
//

import UIKit




extension UIButton {
    
    convenience public init(title: String, titleColor: UIColor, font: UIFont = .systemFont(ofSize: 14), backgroundColor: UIColor = .clear, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        
        self.backgroundColor = backgroundColor
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    convenience public init(image: UIImage, tintColor: UIColor? = nil, target: Any? = nil, action: Selector? = nil) {
        self.init(type: .system)
        if tintColor == nil {
            setImage(image, for: .normal)
        } else {
            setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            self.tintColor = tintColor
        }
        
        imageView?.contentMode = .scaleAspectFit
        
        if let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
}

extension UIView {
    
    enum AnimationKeyPath: String {
        case opacity = "opacity"
    }
    
    func continousAnimating(withDuration duration: TimeInterval = 0.5){
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.alpha = 0.3
        })
    }
}
