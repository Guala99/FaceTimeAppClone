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
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    var faceTimeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FaceTime..."
        label.textAlignment = .center
        return label
    }()
    
    lazy var bottomBar : BottomBar = {
        let bar = BottomBar()
        bar.delegate = self
        return bar
    }()
    
    let cameraNotAvailable : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Camera Not Available"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var isMuted : Bool = false
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    var previewView =  UIView()
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    
    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()

    var permissionView : CamPermissionView = {
        let permission = CamPermissionView()
        permission.allowCamButton.addTarget(self, action: #selector(handleCamTapped), for: .touchUpInside)
        return permission
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        previewView.contentMode = UIView.ContentMode.scaleToFill
        previewView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        view.addSubview(previewView)
        
        view.addSubview(nameCallerLabel)
        nameCallerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        nameCallerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        nameCallerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(faceTimeLabel)
        faceTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        faceTimeLabel.widthAnchor.constraint(equalTo: nameCallerLabel.widthAnchor, multiplier: 0.5).isActive = true
        faceTimeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        faceTimeLabel.topAnchor.constraint(equalTo: nameCallerLabel.bottomAnchor, constant: 15).isActive = true
        
        view.addSubview(bottomBar)
        bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        self.setupAVCapture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nameCallerLabel.continousAnimating(withDuration: 0.75)
        self.presentButtonsForCameraAccess()
        self.addblurredView()
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
    
    
    func addblurredView(){
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.insertSubview(blurEffectView, at: 0)
        blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    fileprivate func presentButtonsForCameraAccess(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (response) in
            if response {
                //access granted
                DispatchQueue.main.async {
                    self.permissionView.isCamAllowed = true
                    self.permissionView.removeFromSuperview()
                }
            } else {
                DispatchQueue.main.async {
                    if !self.permissionView.isHidden{
                        self.presentStackViewPermission()
                    }
                }
            }
        }
    }
    
    
    func presentStackViewPermission(){
        self.view.addSubview(permissionView)
        self.permissionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.permissionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.permissionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.permissionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    @objc func handleCamTapped(){
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}

@available(iOS 13.0, *)
extension CallController : AVCaptureVideoDataOutputSampleBufferDelegate{
    func setupAVCapture(){
        
        session.sessionPreset = AVCaptureSession.Preset.vga640x480
        guard let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                         for: .video,
                         position: AVCaptureDevice.Position.front) else {
                    self.presentCameraNotAvailable()
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
    
    func presentCameraNotAvailable(){
        self.view.addSubview(cameraNotAvailable)
        cameraNotAvailable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraNotAvailable.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraNotAvailable.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        self.addblurredView()
    }
    
}



@available(iOS 13.0, *)
extension CallController : BottomBarDelegate {
    func answerTapped() {
        
    }
    
    func declineTapped() {
        self.dismiss(animated: true)
    }
    
    func changeOrientationTapped() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let currentCameraInput: AVCaptureInput = self.session.inputs.first else { return }
            self.session.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                newCamera = self.cameraWithPosition(position: .front)!
            } else {
                newCamera = self.cameraWithPosition(position: .back)!
            }
            
            do {
                let newVideoInput = try AVCaptureDeviceInput(device: newCamera)
                self.session.addInput(newVideoInput)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func muteTapped(sender: UIButton) {
        self.isMuted = !isMuted
        
        if isMuted{
            print(sender)
            sender.setImage(UIImage(named: "unmuteButton")!.withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            print(sender)
            sender.setImage(UIImage(named: "muteButton")!.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == position {
                return device as? AVCaptureDevice
            }
        }
        return nil
    }
}
