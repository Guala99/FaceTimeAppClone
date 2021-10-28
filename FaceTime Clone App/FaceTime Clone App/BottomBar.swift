//
//  BottomBar.swift
//  FaceTime Clone App
//
//  Created by Andrea Gualandris on 28/10/2021.
//

import UIKit

protocol BottomBarDelegate : AnyObject{
    
}

@available(iOS 11.0, *)
class BottomBar : UIView {
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .darkGray
        self.clipsToBounds = true
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setUpButtons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButtons(){
        var buttons : [UIButton] = []
        for _ in 1...4{
            let button = UIButton()
            button.backgroundColor = .yellow
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        
        
    }
    
    
}
