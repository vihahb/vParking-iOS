//
//  QRCodeScannerViewController.swift
//  VParking
//
//  Created by TD on 3/6/17.
//  Copyright © 2017 xtel. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown
class QRCodeScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var dataVerhicles = [VerhicleEntity]()
    var dataSource = [String]()
    var presenter:QRCodeScannerPresenter!
    var index:Int = 0
    
    @IBOutlet weak var vCamera: UIView!
    @IBOutlet weak var vCapture: UIView!
    let dropDown:DropDown = DropDown()
    @IBOutlet weak var imgDropdown: UIImageView!
    @IBOutlet weak var lblDropdown: UILabel!
    @IBOutlet weak var vDropdown: UIView!
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
        let v:VerhicleEntity = self.dataVerhicles[index]
        presenter.checkIn(code: code, verhicle_id: v.id, verhicle_type: v.type, name: v.name!)
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
   
    @IBAction func verhicleTap(_ sender: Any) {
        dropDown.show()
    }
}

extension QRCodeScannerViewController : IQRCodeScannerView{
    func Initialization() {
        presenter = QRCodeScannerPresenter(view:self)
        
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
        
        vCapture.layer.zPosition = 1
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = vCamera.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        vCamera.layer.addSublayer(previewLayer)
        setUpDropDown()
        presenter.getVerhicle()
    }
    
    func verhicle(didResult verhicles: [VerhicleEntity]?, error: NIPError?) {
        if let _ = error {
            let alert = UIAlertController(title: "Thông báo", message: "Không lấy được dữ liệu xe cá nhân vui long thử lại.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (ac) in
                self.close()
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let d = verhicles {
            if d.count <= 0 {
                let alert = UIAlertController(title: "Thông báo", message: "Bạn chưa tạo phương tiện cá nhân. Vui lòng tạo phương tiện cá nhân để checkin.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (ac) in
                    self.close()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        dataVerhicles = verhicles!
        dataSource.removeAll()
        dataVerhicles.forEach { (v) in
            dataSource.append(v.name!)
        }
        dropDown.dataSource = dataSource
        dropDown.selectRow(at: 0)
        captureSession.startRunning()
    }
    func showCheckInError(message: String) {
        self.view.makeToast(message)
        close()
    }
    func showCheckInErrorAndReCheckIn(message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Thử lại", style: .default) { (ac) in
                    if (!(self.captureSession?.isRunning)!){
                        self.captureSession.startRunning()
                    }
        }
        let cancle = UIAlertAction(title: "Thoát", style: .destructive) { (ac) in
            self.close()
        }
        alert.addAction(okAction)
        alert.addAction(cancle)
        self.present(alert, animated: true, completion: nil)
        
    }
    func checkInSuccess() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn đã checkin thành công tại bãi gửi xe \(dataVerhicles[index].name!)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (ac) in
            self.close()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func setUpDropDown(){
        dropDown.anchorView = vDropdown
        dropDown.dataSource = dataSource
        dropDown.width = 200
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.cancelAction = {() in
            self.imgDropdown.image = #imageLiteral(resourceName: "ic_action_arrow_down")
        }
        dropDown.willShowAction = { () in
            self.imgDropdown.image = #imageLiteral(resourceName: "ic_action_arrow_up")
        }
        dropDown.selectionAction = {(index,item) in
            self.imgDropdown.image = #imageLiteral(resourceName: "ic_action_arrow_down")
            self.lblDropdown.text = item
            self.index = index
        }
        
    }
    
}
