//
//  DownloadAppVC.swift
//  DemoAnswersAi
//
//  Created by Brijesh Ajudia on 02/12/24.
//

import UIKit
import LocalAuthentication

class DownloadAppVC: UIViewController {
    
    @IBOutlet weak var lblAppName: UILabel!
    
    @IBOutlet weak var circularProgressView: CircularProgressView!
    
    var appData: AppData?
    
    private var progressTimer: Timer?
    private var isFirstClick = true
    private var isPaused = false
    private var currentProgress: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblAppName.text = self.appData?.appName
        circularProgressView.progress = currentProgress
        
        // Create and configure the pause button
        let pauseButton = UIButton(frame: CGRect(x: circularProgressView.bounds.midX - 15, y: circularProgressView.bounds.midY - 15, width: 30, height: 30))
        pauseButton.layer.cornerRadius = 5
        pauseButton.backgroundColor = .systemBlue
        pauseButton.setTitle("", for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        pauseButton.tag = 999
        circularProgressView.addSubview(pauseButton)
    }
    
    //MARK: - Require Touch/Face ID Method
    func reqiresAuthnticate(callback:((_ status: Bool?) -> Void)?) {
        let myContext = LAContext()
        var myLocalizedReasonString = String()
        var privacyText: String = ""
        if DeviceUtility.deviceHasTopNotch == false {
            myLocalizedReasonString = "Touch ID is required to use Your Wallet!"
            privacyText = "Touch ID"
        }
        else {
            myLocalizedReasonString = "Face ID is required to use Your Wallet!"
            privacyText = "Face ID"
        }
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { (sucess, evaluateError) in
                    if sucess {
                        DispatchQueue.main.async { [unowned self] in
                            Utils.showToastMessage(title: "Successfully! You've matched with \(privacyText)", messageColor: .white, backGoundColor: .black)
                            callback?(true)
                        }
                    }
                    else {
                        print(evaluateError?.localizedDescription ?? "Failed to authenticate")
                        DispatchQueue.main.async { [unowned self] in
                            Utils.showToastMessage(title: "Unsuccessful! You've not matched with \(privacyText)", messageColor: .white, backGoundColor: .black)
                            callback?(false)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async { [unowned self] in
                    Utils.showToastMessage(title: "Unsuccessful! You've not matched with \(privacyText)", messageColor: .white, backGoundColor: .black)
                    callback?(false)
                }
            }
        } else {
            Utils.showToastMessage(title: "You've not enabled \(privacyText), Please first enable it.", messageColor: .white, backGoundColor: .black)
            callback?(false)
        }
    }
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func startProgress() {
        if !isPaused {
            currentProgress = 0.0
        }
        isPaused = false
        progressTimer?.invalidate()
        progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgress() {
        // Update the progress value
        if currentProgress < 1.0 {
            currentProgress += 0.01
            circularProgressView.progress = currentProgress
        } else {
            progressTimer?.invalidate()
            
            if let view = circularProgressView.viewWithTag(999) {
                view.isHidden = true
            }
            circularProgressView.isCompleted = true // Mark as completed and replace with tick image
        }
    }
    
    @objc private func pauseButtonTapped() {
        if isFirstClick {
            // Handle the first click
            isFirstClick = false
            isPaused = false
            currentProgress = 0.0
            circularProgressView.progress = currentProgress
            
            // Start authentication process
            self.reqiresAuthnticate { [weak self] status in
                guard let self = self else { return }
                if status == true {
                    DispatchQueue.main.async {
                        self.startProgress()
                    }
                } else {
                    print("Authentication failed")
                }
            }
        } else if isPaused {
            // Resume progress animation
            isPaused = false
            currentProgress = 0.0 // Reset progress
            circularProgressView.progress = currentProgress
            
            // Start authentication process
            self.reqiresAuthnticate { [weak self] status in
                guard let self = self else { return }
                if status == true {
                    DispatchQueue.main.async {
                        self.startProgress()
                    }
                } else {
                    print("Authentication failed")
                }
            }
        } else {
            // Pause the progress
            isPaused = true
            currentProgress = 0.0
            circularProgressView.progress = currentProgress
            progressTimer?.invalidate() // Stop the timer
        }
    }
    
}


class CircularProgressView: UIView {
    
    private var progressLayer: CAShapeLayer!
    private var trackLayer: CAShapeLayer!
    private var radius: CGFloat = 30
    private var lineWidth: CGFloat = 4
    var progress: CGFloat = 0.0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }
    var isCompleted: Bool = false {
        didSet {
            updateViewForCompletion()
        }
    }
    
    private var pauseButton: UIButton!
    private var tickImageView: UIImageView!
    private var isPaused = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        // Track Layer (the background circle)
        trackLayer = CAShapeLayer()
        trackLayer.path = path.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        // Progress Layer (the animated circle)
        progressLayer = CAShapeLayer()
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
        
        pauseButton = UIButton(frame: CGRect(x: bounds.midX - 15, y: bounds.midY - 15, width: 30, height: 30))
        pauseButton.layer.cornerRadius = 5
        pauseButton.backgroundColor = .systemBlue
        pauseButton.setTitle("", for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        addSubview(pauseButton)
        
        // Tick Image View (hidden initially)
        tickImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        tickImageView.tintColor = .systemBlue
        tickImageView.frame = CGRect(x: bounds.midX - 15, y: bounds.midY - 15, width: 30, height: 30)
        tickImageView.isHidden = true
        addSubview(tickImageView)
    }
    
    @objc func pauseButtonTapped() {
        isPaused.toggle()
        if isPaused {
            // Reset progress to 0 and notify the controller
            progress = 0.0
        }
    }
    
    private func updateViewForCompletion() {
        if isCompleted {
            pauseButton.isHidden = true
            tickImageView.isHidden = false
        } else {
            pauseButton.isHidden = false
            tickImageView.isHidden = true
        }
    }
}
