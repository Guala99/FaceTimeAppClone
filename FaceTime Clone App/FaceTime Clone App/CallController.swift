//
//  CallController.swift
//  FaceTime Clone App
//
//  Created by Andrea Gualandris on 27/10/2021.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class CallController : UIViewController{
    
    var nameCallerLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Username Prova"
        label.textAlignment = .center
        return label
    }()
    
    var faceTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FaceTime..."
        label.textAlignment = .center
        return label
    }()
    
    var bottomBar = BottomBar()
    
    var previewView =  UIView()
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    
    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        previewView.contentMode = UIView.ContentMode.scaleToFill
        previewView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        
        view.addSubview(previewView)
        
        
        view.addSubview(nameCallerLabel)
        nameCallerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        nameCallerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        nameCallerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameCallerLabel.flash(animation: .opacity, withDuration: 2)
        
        view.addSubview(faceTimeLabel)
        faceTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceTimeLabel.widthAnchor.constraint(equalTo: nameCallerLabel.widthAnchor, multiplier: 0.5).isActive = true
        faceTimeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        faceTimeLabel.topAnchor.constraint(equalTo: nameCallerLabel.bottomAnchor, constant: 15).isActive = true
        
        view.addSubview(bottomBar)
        bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.setupAVCapture()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func onClickMyButton(sender: UIButton){
        print("button pressed")
    }
    
    
    
}

@available(iOS 13.0, *)
extension CallController : AVCaptureVideoDataOutputSampleBufferDelegate{
    func setupAVCapture(){
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        guard let device = AVCaptureDevice
                .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                         for: .video,
                         position: AVCaptureDevice.Position.front) else {
                    return
                }
        captureDevice = device
        
        self.beginSession()
        
        
    }
    
    func beginSession(){
        var deviceInput: AVCaptureDeviceInput!
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("don't find device input")
                return
            }
            
            if self.session.canAddInput(deviceInput){
                self.session.addInput(deviceInput)
            }
            
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames=true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
            
            if session.canAddOutput(self.videoDataOutput){
                session.addOutput(self.videoDataOutput)
            }
            
            videoDataOutput.connection(with: .video)?.isEnabled = true
            
            previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            let rootLayer :CALayer = self.previewView.layer
            rootLayer.masksToBounds=true
            previewLayer.frame = rootLayer.bounds
            
            rootLayer.addSublayer(self.previewLayer)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self!.session.startRunning()
            }
            
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // do stuff here
    }
    
    // clean up AVCapture
    func stopCamera(){
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }
    
}


extension UIView {

    enum AnimationKeyPath: String {
        case opacity = "opacity"
    }

    func flash(animation: AnimationKeyPath ,withDuration duration: TimeInterval = 0.5){
        let flash = CABasicAnimation(keyPath: animation.rawValue)
        flash.duration = duration
        flash.fromValue = 1 // alpha
        flash.toValue = 0 // alpha
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        flash.autoreverses = true
        flash.repeatCount = .greatestFiniteMagnitude

        layer.add(flash, forKey: nil)
    }
}
