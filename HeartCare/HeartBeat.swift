//
//  HeartBeat.swift
//  HeartCare
//
//  Created by 222 on 2019/4/13.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit
import AVFoundation

//protocol HeartBeatPluginDelegate {
//    func startHeartDelegateRatePoint(_ point: CGPoint)
//    func startHeartDelegateRateError(_ error: Error)
//    func startHeartDelegateRateFrequency(_ frequency: Int)
//}

enum DeviceError: Error {
	case notAvailable
	func description() -> String {
		switch self {
		case .notAvailable:
			return "相机不可用"
		default:
			return ""
		}
	}
	func content() -> String {
		switch self {
		case .notAvailable:
			return "相机不可用,或没有使用相机权限。"
		default:
			return ""
		}
	}
}

/*xclass HeartBeat: NSObject {
	
	static let share = HeartBeat()
	
	typealias BackPointCallBack = ((CGPoint) -> Void)
	typealias FrequencyCallBack = ((Int) -> Void)
	typealias ErrorCallBack = ((Error) -> Void)
	
	var backPointCallBack: BackPointCallBack?
	var frequencyCallBack: FrequencyCallBack?
	var errorCallBack: ErrorCallBack?
	
	var delegate: HeartBeatPluginDelegate?
	
	private var device: AVCaptureDevice?
	private var session: AVCaptureSession?
	private var input: AVCaptureInput?
	private var output: AVCaptureVideoDataOutput?
	private var points: [CGPoint]?
	
	static var lastH: Float = 0
	static var count: Int = 0
	static var wait_t: Float = 1.5
	static var is_wait = false
    let T: Float = 10
	
	private override init() {
		
	}
	
	func startHeartRatePoint(_ backPoint: @escaping BackPointCallBack, _ frequency: @escaping FrequencyCallBack, _ error: @escaping ErrorCallBack) {
		backPointCallBack = backPoint
		frequencyCallBack = frequency
		errorCallBack = error
		start()
	}
	
	func start() {}
	func stop() {}
	
	func setupCapture() {
		let type = AVMediaType.video
		let authStatus = AVCaptureDevice.authorizationStatus(for: type)
		if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
			if backPointCallBack != nil { errorCallBack!(DeviceError.notAvailable) }
			delegate?.startHeartDelegateRateError(DeviceError.notAvailable)
			return
		}
		//开启闪光灯
		if (device?.isTorchModeSupported(.on))! {
			try! device?.lockForConfiguration()
			device?.torchMode = .on
			try! device?.setTorchModeOn(level: 0.01)
			device?.unlockForConfiguration()
		}
		//配置input output
		session?.beginConfiguration()
		//配置像素输出格式
		let setting = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA]
		output?.videoSettings = setting as [String : Any]
		//抛弃延迟帧 暂不抛弃
		output?.alwaysDiscardsLateVideoFrames = false
		let outputQueue = DispatchQueue(label: "VideoDataOutputQueue")
		output?.setSampleBufferDelegate(self, queue: outputQueue)
		//向session添加
		if session!.canAddInput(input!) { session?.addInput(input!) }
		if session!.canAddOutput(output!) { session?.addOutput(output!) }
		//减少分辨率，减少f采样率
		session?.sessionPreset = .vga640x480
		//设置视频输出的最小间隔
		device?.activeVideoMinFrameDuration = CMTime(value: 1, timescale: 10)
		//初始化connection
		let connection = output?.connection(with: .video)
		connection?.videoOrientation = .portrait
		//完成编辑
		session?.commitConfiguration()
	}
	
	// MARK: - 分析瞬时心率
	func analysisPointWith(_ point: CGPoint) {
		guard let points = points else { return }
		if points.count <= 30 { return }
		let count = points.count
		if points.count % 10 == 0 {
			var d_i_c = 0
			var d_i_l = 0
			var d_i_r = 0
			
			var trough_c: Float = 0
			var trough_l: Float = 0
			var trough_r: Float = 0
			
            //1.先确定数据中的最低峰值
			for i in 0 ..< count {
				let trough = Float(points[i].y)
				if trough < trough_c {
					trough_c = trough
                    d_i_c = i
				}
			}
            
            //2.找到最低峰值以后 以最低峰值为中心 找到前0.5 - 1.5周期中的最低峰值 和 后0.5 - 1.5周期的最低峰值
            if d_i_c >= Int(1.5 * T) {
                //a.如果最低峰值处在中心位置，即距离前后都至少有1.5个周期
                if d_i_c <= count - Int(1.5 * T) {
                    //左边最低峰值
                    for j in (d_i_c - Int(1.5 * T) ..< d_i_c - Int(0.5 * T)).reversed() {
                        let trough = Float(points[j].y)
                        if trough < trough_l, (d_i_c - j) <= Int(T) {
                            trough_l = trough
                            d_i_l = j
                        }
                    }
                    //右面最低峰值
                    for k in d_i_c + Int(0.5 * T) ..< d_i_c + Int(1.5 * T) {
                        let trough = Float(points[k].y)
                        if trough < trough_l, k - d_i_c <= Int(T) {
                            trough_r = trough
                            d_i_r = k
                        }
                    }
                }
                //b.如果最低峰值右面不够1.5个周期 分两种情况 不够0.5个周期和够0.5个周期
                else if d_i_r < Int(1.5 * T) {
                    //b.1 够0.5个周期
                    if d_i_c < count - Int(0.5 * T) {
                        //左面最低峰值
                        for j in (d_i_c - Int(1.5 * T) ..< d_i_c - Int(0.5 * T)).reversed() {
                            let trough = Float(points[j].y)
                            if trough < trough_l, d_i_c <= Int(T) {
                                trough_l = trough
                                d_i_l = j
                            }
                        }
                        // 右边最低峰值
                        for k in d_i_c + Int(0.5 * T) ..< count {
                            let trough = Float(points[k].y)
                            if trough < trough_r, k - d_i_c <= Int(T) {
                                trough_r = trough
                                d_i_r = k
                            }
                        }
                    }
                    // b.2 不够0.5个周期
                    else {
                        // 左面最低峰值
                        for j in d_i_c - Int(1.5 * T) ..< d_i_c - Int(0.5 * T) {
                            let trough = Float(points[j].y)
                            trough_l = trough
                            d_i_l = j
                        }
                    }
                }
                // c.如果左面不够1.5个周期 一样 分两种情况 够0.5个周期 不够 0.5个周期
                else if d_i_l < Int(1.5 * T) {
                    // c.1 够0.5个周期
                    if d_i_c > Int(0.5 * T) {
                        
                    }
                }
            }
		}
	}
}

extension HeartBeat: AVCaptureVideoDataOutputSampleBufferDelegate {
	
 }*/
