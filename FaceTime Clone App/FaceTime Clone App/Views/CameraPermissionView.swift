//
//  CameraPermissionView.swift
//  FaceTime Clone App
//
//  Created by Andrea Gualandris on 28/10/2021.
//

import UIKit

class CamPermissionView : UIView {
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Go to settings"
        label.font = UIFont(name: "avenir-black", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let allowCamButton : UIButton = {
        let button = UIButton(title: "", titleColor: #colorLiteral(red: 0.2352941176, green: 0.5803921569, blue: 0.9333333333, alpha: 1), font: UIFont(name: "avenir-medium", size: 17)!, backgroundColor: .clear, target: nil, action: nil)
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: "Allow Camera",attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
        return button
    }()
    
    var isCamAllowed : Bool = false {
        didSet{
            if self.isCamAllowed == true{
                self.allowCamButton.setTitleColor(.darkGray, for: .normal)
            }else{
                self.allowCamButton.setTitleColor(#colorLiteral(red: 0.2352941176, green: 0.5803921569, blue: 0.9333333333, alpha: 1), for: .normal)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpUI(){
        self.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [titleLabel, allowCamButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}
