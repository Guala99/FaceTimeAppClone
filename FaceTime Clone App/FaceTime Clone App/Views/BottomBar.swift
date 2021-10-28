//
//  BottomBar.swift
//  FaceTime Clone App
//
//  Created by Andrea Gualandris on 28/10/2021.
//

import UIKit

protocol BottomBarDelegate : AnyObject{
    func answerTapped()
    func declineTapped()
    func changeOrientationTapped()
    func muteTapped(sender: UIButton)
}

@available(iOS 11.0, *)
class BottomBar : UIView {
    
    let answerButton = UIButton(image: UIImage(named: "answerCall")!.withRenderingMode(.alwaysOriginal), tintColor: nil, target: self, action: #selector(answerTapped))
    
    let muteButton = UIButton(image: UIImage(named: "muteButton")!.withRenderingMode(.alwaysOriginal), tintColor: nil, target: self, action: #selector(muteTapped))
    
    let flipButton = UIButton(image: UIImage(named: "flipCameraButton")!.withRenderingMode(.alwaysOriginal), tintColor: nil, target: self, action: #selector(flipTapped))
    
    let cancelButton = UIButton(image: UIImage(named: "cancelButton")!.withRenderingMode(.alwaysOriginal), tintColor: nil, target: self, action: #selector(cancelTapped))
    
    weak var delegate : BottomBarDelegate?
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(white: 0.15, alpha: 1)
        self.clipsToBounds = true
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setUpButtons()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpButtons(){
        
        
        let stackView = UIStackView(arrangedSubviews: [answerButton, muteButton,flipButton, cancelButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        
        
        }
    
    @objc fileprivate func answerTapped(){
        self.delegate?.answerTapped()
    }
    
    @objc fileprivate func muteTapped(){
        self.delegate?.muteTapped(sender: muteButton)
    }
    
    @objc fileprivate func flipTapped(){
        self.delegate?.changeOrientationTapped()
    }
                
    @objc fileprivate func cancelTapped(){
        self.delegate?.declineTapped()
    }
                
}
