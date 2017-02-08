//
//  CameraViewController.swift
//  DietSupport
//
//  Created by kenji imoto on 2017/01/27.
//  Copyright © 2017年 TMS. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController{
    
    enum FlashMode {
        case on
        case off
        case auto
    }
    
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var input:AVCaptureDeviceInput!
    var output:AVCaptureStillImageOutput!
    var session:AVCaptureSession!
    var preView:UIView!
    var imgView:UIImageView!
    var camera:AVCaptureDevice!
    var takeImg:UIImage = UIImage()
    var imageData:Data = Data()
    
    @IBOutlet weak var takeBtn: UIButton!
    @IBOutlet weak var fixBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    @IBOutlet weak var personBtn: UIButton!
    @IBOutlet weak var flashBtn: UIButton!
    @IBOutlet weak var hantenBtn: UIButton!
    
    var isBackCamera: Bool = true
    var isUsePerson: Bool = false
    var isFlashMode: FlashMode = .off
    var oldZoomScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        fixBtn.isHidden = true
        retakeBtn.isHidden = true;
        
        if appDelegate.cameraMode == .menuCamera {
            personBtn.isHidden = true;
        }
        // 画面タップでシャッターを切るための設定
        //let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        // デリゲートをセット
        //tapGesture.delegate = self;
        // Viewに追加.
        //self.view.addGestureRecognizer(tapGesture)
        
        
    }
    
    // メモリ管理のため
    override func viewWillAppear(_ animated: Bool) {
        // スクリーン設定
        setupDisplay()
        // カメラの設定
        setupCamera(isBackCamera)
    }
    
    // メモリ管理のため
    override func viewDidDisappear(_ animated: Bool) {
        // camera stop メモリ解放
        session.stopRunning()
        
        for output in session.outputs {
            session.removeOutput(output as? AVCaptureOutput)
        }
        
        for input in session.inputs {
            session.removeInput(input as? AVCaptureInput)
        }
        session = nil
        camera = nil
    }
    
    func setupDisplay(){
        // プレビュー用のビューを生成
        
        // Status Barの高さを取得する.
        let barHeight: CGFloat? = UIApplication.shared.statusBarFrame.size.height
        let barHeight2: CGFloat? = self.navigationController?.navigationBar.frame.size.height
        
        preView = UIView(frame: CGRect(x: 0.0, y: barHeight!+barHeight2!, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*1.33))
        
    }
    
    func setupCamera(_ isBack: Bool){
        
        // セッション
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset640x480
        
        /*
        for caputureDevice: Any in AVCaptureDevice.devices() {
            // 背面カメラを取得
            if caputureDevice.position == AVCaptureDevicePosition.Back {
                camera = caputureDevice as? AVCaptureDevice
            }
            // 前面カメラを取得
            //if caputureDevice.position == AVCaptureDevicePosition.Front {
            //    camera = caputureDevice as? AVCaptureDevice
            //}
        }*/
        
        // カメラからの入力データ
        
        
        //let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        guard let devices = AVCaptureDevice.devices() else {
            return
        }
        for device in devices {
            // isBack == True  -> Back Camera
            // iSBack == False -> Front Camera
            let devicePosition: AVCaptureDevicePosition = isBack ? .back : .front
            if (device as AnyObject).position == devicePosition {
                camera = device as! AVCaptureDevice
            }
        }
        
        do {
            input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }
        
        // 入力をセッションに追加
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        
        // 静止画出力のインスタンス生成
        output = AVCaptureStillImageOutput()
        // 出力をセッションに追加
        if(session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        // セッションからプレビューを表示を
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer!.frame = preView.frame
        
        //        previewLayer.videoGravity = AVLayerVideoGravityResize
        //        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // レイヤーをViewに設定
        // これを外すとプレビューが無くなる、けれど撮影はできる
        self.view.layer.addSublayer(previewLayer!)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchedGesture(_:)))
        //preView.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(pinchGesture)
        
        session.startRunning()
    }
    
    @IBAction func takeStillPicture(_ sender: UIButton){
        print("撮影")
        
        // ビデオ出力に接続.
        if let connection:AVCaptureConnection? = output.connection(withMediaType:AVMediaTypeVideo){
            // ビデオ出力から画像を非同期で取得
            output.captureStillImageAsynchronously(from: connection!, completionHandler: { (imageDataBuffer, error) -> Void in
                
                // 取得画像のDataBufferをJpegに変換
                self.imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                
                // JpegからUIImageを作成.
                self.takeImg = UIImage(data: self.imageData)!
                print("* \(self.takeImg.size.width) \(self.takeImg.size.height)")
                
                // Status Barの高さを取得する.
                let barHeight: CGFloat? = UIApplication.shared.statusBarFrame.size.height
                let barHeight2: CGFloat? = self.navigationController?.navigationBar.frame.size.height
                
                self.imgView = UIImageView(frame: CGRect(x: 0.0, y: barHeight!+barHeight2!, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*1.33))
                self.imgView.image = self.takeImg
                self.view.addSubview(self.imgView)
                
                self.fixBtn.isHidden = false;
                self.retakeBtn.isHidden = false;
                self.takeBtn.isHidden = true;
                self.flashBtn.isHidden = true;
                self.hantenBtn.isHidden = true;
                
                if self.appDelegate.cameraMode == AppDelegate.CameraMode.dayWorkout {
                    self.personBtn.isHidden = true;
                }
            })
        }
    }
    
    func pinchedGesture(_ gestureRecgnizer: UIPinchGestureRecognizer) {
        do {
            try camera.lockForConfiguration()
            // ズームの最大値
            let maxZoomScale: CGFloat = 6.0
            // ズームの最小値
            let minZoomScale: CGFloat = 1.0
            // 現在のカメラのズーム度
            var currentZoomScale: CGFloat = camera.videoZoomFactor
            // ピンチの度合い
            let pinchZoomScale: CGFloat = gestureRecgnizer.scale
            
            // ピンチアウトの時、前回のズームに今回のズーム-1を指定
            // 例: 前回3.0, 今回1.2のとき、currentZoomScale=3.2
            if pinchZoomScale > 1.0 {
                currentZoomScale = oldZoomScale+pinchZoomScale-1
            } else {
                currentZoomScale = oldZoomScale-(1-pinchZoomScale)*oldZoomScale
            }
            
            // 最小値より小さく、最大値より大きくならないようにする
            if currentZoomScale < minZoomScale {
                currentZoomScale = minZoomScale
            }
            else if currentZoomScale > maxZoomScale {
                currentZoomScale = maxZoomScale
            }
            
            // 画面から指が離れたとき、stateがEndedになる。
            if gestureRecgnizer.state == .ended {
                oldZoomScale = currentZoomScale
            }
            
            camera.videoZoomFactor = currentZoomScale
            camera.unlockForConfiguration()
        } catch {
            // handle error
            return
        }
    }
    
    @IBAction func changeUseCamera(_ sender: Any) {
        isBackCamera = !isBackCamera
        setupCamera(isBackCamera)
    }
    
    @IBAction func changeFlashMode() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device!.hasTorch) {
            do {
                try device!.lockForConfiguration()
                if isFlashMode == .off {
                    device?.flashMode = .on
                    isFlashMode = .on
                    flashBtn.setTitle("on", for: .normal)
                }else if isFlashMode == .on {
                    device?.flashMode = .auto
                    isFlashMode = .auto
                    flashBtn.setTitle("auto", for: .normal)
                }else if isFlashMode == .auto {
                    device?.flashMode = .off
                    isFlashMode = .off
                    flashBtn.setTitle("off", for: .normal)
                }
                device!.unlockForConfiguration()
            } catch {
                // handle error
                return
            }
        }
    }
    
    @IBAction func usePhoto(_ sender: UIButton){
        print("写真を使用")
        if appDelegate.cameraMode == .dayWorkout {
            appDelegate.workoutKekkaVC.setCameraBtnImg(takeImg, data: imageData)
        }else{
            appDelegate.menuSelectVC.setCameraBtnImg(takeImg, data: imageData)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeUsePerson(_ sender: UIButton){
        print("人を出す")
        if !isUsePerson {
            let imgView = UIImageView(frame: CGRect(x: 0, y: preView.frame.origin.y, width: preView.frame.width, height: preView.frame.height))
            imgView.image = UIImage(data: appDelegate.selectedMenuT.gazo)
            imgView.alpha = 0.3
            self.view.addSubview(imgView)
            isUsePerson = true
            print("人を出すーーーー　\(appDelegate.selectedMenuT.gazo.count)")
        }else{
            for subview in self.view.subviews {
                if subview is UIImageView {
                    subview.removeFromSuperview()
                }
            }
            isUsePerson = false
        }
    }
    
    @IBAction func retake(_ sender: UIButton){
        imgView.removeFromSuperview()
        fixBtn.isHidden = true
        retakeBtn.isHidden = true;
        self.takeBtn.isHidden = false;
        
        self.flashBtn.isHidden = false;
        self.hantenBtn.isHidden = false;
        
        if self.appDelegate.cameraMode == .dayWorkout {
            self.personBtn.isHidden = false;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
