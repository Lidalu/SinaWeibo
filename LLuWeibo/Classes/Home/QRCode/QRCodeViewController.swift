//
//  QRCodeViewController.swift
//  LLuWeibo
//
//  Created by ma c on 16/4/24.
//  Copyright © 2016年 lu. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, UITabBarDelegate {
    
    //扫描容器的高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    //冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    @IBAction func closeBtnClick(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    //底部视图
    @IBOutlet weak var customTabBar: UITabBar!
    /**
     监听名片按钮点击
     */
    @IBAction func myCardBtnClick(sender: AnyObject) {
        
        let QRCodeCardVC = QRCodeCardViewController()
        
        navigationController?.pushViewController(QRCodeCardVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        //1.设置底部视图
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        //1.开始冲击波动画
        startAnimation()
        
        //2.开始扫描
        startScan()
    }
    
    private func startScan() {
        
        //1.判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput) {
            
            return
        }
        //2.判断是否能够将输出添加到会话中
        if !session.canAddOutput(deviceOutput) {
            
            return
        }
        //3.输入和输出都添加到会话中
        session.addInput(deviceInput)
        //能够解析的类型
        print(deviceOutput.availableMetadataObjectTypes)
        session.addOutput(deviceOutput)
        print(deviceOutput.availableMetadataObjectTypes)
        //4.设置输出能够解析的数据类型
        //注意：设置能够解析的数据类型，一定要在输出对象添加到会员之后设置，否则会报错
        deviceOutput.metadataObjectTypes = deviceOutput.availableMetadataObjectTypes
        //5.设置输出对象的代理，只要解析成功就会通知代理
        deviceOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        // WARNING - 如果想实现只扫描一张图片，那么系统自带的二维码扫描是不支持的
        //只能设置让二维码只要出现在某一块区域才去扫描
        deviceOutput.rectOfInterest = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        
        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        //6.告诉session开始扫描
        session.startRunning()
    }
    
    /**
     执行动画
     */
    private func startAnimation(){
    
        //让约束从顶部开始
        self.scanLineCons.constant = -self.containerHeightCons.constant
        self.scanLineView.layoutIfNeeded()
        //执行冲击波动画
        UIView.animateWithDuration(5.0, animations: {
        
        //1.修改约束
        self.scanLineCons.constant = self.containerHeightCons.constant
        //设置动画指定的次数
        UIView.setAnimationRepeatCount(MAXFLOAT)
        //2.强制更新界面
        self.scanLineView.layoutIfNeeded()
        
        })
    }
    
    // MARK - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        //1.修改容器的高度
        if item.tag == 1 {
            
            print("二维码")
            self.containerHeightCons.constant = 300
        } else {
            
            print("条形码")
            self.containerHeightCons.constant = 150
        }
        
        //2.停止动画
        self.scanLineView.layer.removeAllAnimations()
        
        //3.重新开始动画
        startAnimation()
    }
    
    // MARK - 懒加载
    //会话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    //拿到输入设备
    private lazy var deviceInput : AVCaptureDeviceInput? = {
        //获取摄像头
       let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //创建输入对象
        do {
            
            let input = try AVCaptureDeviceInput(device: device)
            return input
        } catch {
            
            print(error)
            return nil
        }
        
    }()
    //拿到输出对象
    private lazy var deviceOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
       
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    //创建预览图层
    private lazy var drawLayer: CALayer = {
        
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    //只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //0.清空图层
        clearConers()
        
        //1.获取扫描到的数据
        //注意：要使用stringValue
        print(metadataObjects.last?.stringValue)
        
        //2.获取扫描到的二维码的位置
        print(metadataObjects.last)
        //2.1转换坐标
        for object in metadataObjects {
            
            //2.1.1判断当前获取到的数据，是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject {
                
                //2.1.2将坐标转换界面可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject (object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
//                print(codeObject)
                //2.1.3绘制图形
                drawCorners(codeObject)
            }
        }
    }
    
    /**
     绘制图形
     
     - parameter codeObject: 保存了坐标的对象
     */
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject) -> Void {
        
        
        if codeObject.corners.isEmpty {
            
            return
        }
        //1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        //2.创建路径
//        layer.path = UIBezierPath(rect: CGRect(x: 100, y: 100, width: 200, height: 200)).CGPath
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0

        //2.1移动到第一个点
        print(codeObject.corners.last)
        //从corners数组中取出第0个元素，将这个字典中的x/y赋值给point
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        //2.2移动到其他的点
        while index < codeObject.corners.count{
            
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        //2.3关闭路径
        path.closePath()
        
        //2.4绘制路径
        layer.path = path.CGPath
        
        //3.将绘制好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
    }
    /**
     *  清空边线
     */
    private func clearConers() {
        
        //1.判断drawLayer上是否有其他图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            
            return
        }
        //2.移除所有子图层
        for subLayer in drawLayer.sublayers! {
            
            subLayer.removeFromSuperlayer()
        }
    }
}

