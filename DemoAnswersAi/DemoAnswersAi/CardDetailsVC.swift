//
//  CardDetailsVC.swift
//  DemoAnswersAi
//
//  Created by Brijesh Ajudia on 02/12/24.
//

import UIKit

class CardDetailsVC: UIViewController {
    
    @IBOutlet weak var viewApp: UIView!
    
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblAppTitle: UILabel!
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    var appData: AppData?
    
    //var expandedView = UIView()
    var blurEffectView: UIVisualEffectView!
    
    var detailsView: UIView!
    var cardDetailsView: CardDetailView?
    
    private var lastContentOffset: CGFloat = 0.0
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewApp.isHidden = true
        self.viewApp.alpha = 0
        viewApp.transform = CGAffineTransform(translationX: 0, y: viewApp.frame.height)
        
        self.setupExpandedView()
        //self.setupDragIndicator()
        self.setupBlurEffectView()
        self.addGestures()
    }
    
    func setupExpandedView() {
        self.cardDetailsView = Bundle.main.loadNibNamed(String(describing: CardDetailView.self), owner: self, options: nil)![0] as? CardDetailView
        
        let height = screenHeight()
        
        let personalDetailsViewFrame = CGRect(x: (sceneDelegate?.window?.frame.origin.x ?? 0), y: (sceneDelegate?.window?.frame.origin.y ?? 0), width: (sceneDelegate?.window?.frame.size.width) ?? 0, height: height)
        
        self.detailsView = UIView(frame: personalDetailsViewFrame)
        
        if DeviceUtility.deviceHasTopNotch == true {
            self.detailsView.layer.cornerRadius = 44
        }
        else {
            self.detailsView.layer.cornerRadius = 0
        }
        
        self.view.addSubview(self.detailsView)
        
        self.cardDetailsView?.frame = personalDetailsViewFrame
        self.cardDetailsView?.appData = self.appData
        self.cardDetailsView?.navVC = self.navigationController
        
        self.cardDetailsView?.setUpData()
        
        self.cardDetailsView?.closeClosure = { param in
            self.collapseView()
        }
        
        self.cardDetailsView?.shareClosure = { share in
            
            let linkToShare = URL(string: "https://www.example.com")!
            
            var filesToShare = [Any]()
            filesToShare.append(linkToShare)
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in }
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        self.cardDetailsView?.getAppClosure = {getApp in
        
            let vc = Utils.getStoryboard(storyboardName: StoryBoard.SB_MAIN).instantiateViewController(withIdentifier: "\(DownloadAppVC.self)") as! DownloadAppVC
            if let sheet = vc.sheetPresentationController{
                sheet.detents = [.customDetent(height: 400 )]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = false
                sheet.preferredCornerRadius = 30
            }
            
            vc.appData = self.appData
            self.present(vc, animated: true)
        }
        
        self.detailsView.addSubview(self.cardDetailsView!)
        
        self.detailsView.bringSubviewToFront(self.viewApp)
        self.viewApp.layer.zPosition = 1
        self.detailsView.layer.zPosition = 0
        
        
    }
    
    func setupDragIndicator() {
        let dragIndicator = UIView(frame: CGRect(x: (detailsView.bounds.width - 40) / 2, y: 10, width: 40, height: 5))
        dragIndicator.backgroundColor = .lightGray
        dragIndicator.layer.cornerRadius = 2.5
        dragIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        detailsView.addSubview(dragIndicator)
    }

    func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 1
        view.insertSubview(blurEffectView, belowSubview: detailsView)
    }

    func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        self.detailsView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        guard let scrollView = cardDetailsView?.scrollView else { return }
        let currentOffset = scrollView.contentOffset.y

        let movePoint: CGFloat = 150
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let point: CGFloat = 150

        print("Y  ---> ", scrollView.contentOffset.y, maxOffset)
        
        if scrollView.contentOffset.y < 0 {
            // Handle drag for showing and hiding the details view
            let translation = gesture.translation(in: self.detailsView)
            
            let newWidth = view.bounds.width - translation.y * 0.5
            let newHeight = view.bounds.height - translation.y
            let newX = (view.bounds.width - newWidth) / 2
            let newY = (view.bounds.height - newHeight) / 2

            // Update the frame while keeping it centered
            self.detailsView.frame = CGRect(
                x: newX,
                y: newY,
                width: newWidth,
                height: newHeight
            )

            let maxTranslation: CGFloat = 140
            let minCornerRadius: CGFloat = 10
            var maxCornerRadius: CGFloat = 44
            
            if DeviceUtility.deviceHasTopNotch == true {
                maxCornerRadius = 44
            }
            else {
                maxCornerRadius = 20
            }
            
            let progress = min(translation.y / maxTranslation, 1.0)
            let cornerRadius = maxCornerRadius - progress * (maxCornerRadius - minCornerRadius)
            self.detailsView.layer.cornerRadius = cornerRadius
            self.detailsView.layer.masksToBounds = true
            
            if translation.y > movePoint || translation.x > movePoint {
                collapseView()
            }
        } else {
            if currentOffset > lastContentOffset && currentOffset > point {
                // Scrolling down
                UIView.animate(withDuration: 0.3) {
                    self.viewApp.isHidden = true
                    self.viewApp.alpha = 0
                    self.viewApp.transform = CGAffineTransform(translationX: 0, y: self.viewApp.frame.height)
                }
            }
            
            else if currentOffset < lastContentOffset && currentOffset <= point {
                // Scrolling up
                UIView.animate(withDuration: 0.3) {
                    self.viewApp.isHidden = false
                    self.viewApp.alpha = 1
                    self.viewApp.transform = .identity
                }
            }

            if currentOffset >= maxOffset {
                UIView.animate(withDuration: 0.3) {
                    self.viewApp.isHidden = true
                    self.viewApp.alpha = 0
                    self.viewApp.transform = CGAffineTransform(translationX: 0, y: self.viewApp.frame.height)
                }
            }

            if currentOffset > point && currentOffset < maxOffset {
                UIView.animate(withDuration: 0.3) {
                    self.viewApp.isHidden = false
                    self.viewApp.alpha = 1
                    self.viewApp.transform = .identity
                }
            }

            lastContentOffset = currentOffset
        }
    }


    
    func collapseView() {
        
        UIView.animate(withDuration: 0.5) {
            self.blurEffectView.effect = nil
            self.blurEffectView.alpha = 0
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func getAppAction(_ sender: UIButton) {
        let vc = Utils.getStoryboard(storyboardName: StoryBoard.SB_MAIN).instantiateViewController(withIdentifier: "\(DownloadAppVC.self)") as! DownloadAppVC
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.customDetent(height: 400 )]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 30
        }
        
        vc.appData = self.appData
        self.present(vc, animated: true)
    }
    
}

extension CardDetailsVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow the pan gesture to work simultaneously with the scroll view
        return true
    }
}
