//
//  QRCodeScannerViewController.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialization()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning)!{
            captureSession.stopRunning()
        }
    }

    func failed() {
        self.view.makeToast("Thiết bị của bạn không hỗi trợ camera vui lòng sử dụng điện thoại có hỗi trợ camera.")
        captureSession = nil
    }
    
    func found(_ code:String){
        view.makeToast("code is \(code)")
    }
    
    func notFound(){
        view.makeToast("Not foud qr code.")
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        if let metadataObject =  metadataObjects.first{
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.found(readableObject.stringValue)
            return
        }
        notFound()
        
    }
}

extension QRCodeScannerViewController : IQRCodeScannerView{
    func Initialization() {
        captureSession = AVCaptureSession()
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        do{
            videoInput = try AVCaptureDeviceInput(device:videoCaptureDevice)
        }catch{
            return
        }
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        }else{
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }else{
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}
