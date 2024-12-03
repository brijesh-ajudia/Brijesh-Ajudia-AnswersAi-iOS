//
//  CardDetailView.swift
//  DemoAnswersAi
//
//  Created by Brijesh Ajudia on 02/12/24.
//

import UIKit

class CardDetailView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var viewGradient: UIView!
    
    @IBOutlet weak var lblSTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet var lblAppName: [UILabel]!
    @IBOutlet var lblAppTitle: [UILabel]!
    
    @IBOutlet weak var btnGet: UIButton!
    
    @IBOutlet weak var lblDescription1: UILabel!
    @IBOutlet weak var lblDescription1Height: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblDescription2: UILabel!
    @IBOutlet weak var lblDescription2Height: NSLayoutConstraint!
    
    var blurEffectView: UIVisualEffectView!
    
    var appData: AppData?
    var navVC: UINavigationController?
    
    var closeClosure: ((_ close: Bool) -> Void)?
    var getAppClosure: ((_ getApp: Bool) -> Void)?
    var shareClosure: ((_ share: Bool) -> Void)?
    
    private var lastContentOffset: CGFloat = 0.0
    
    func setUpData() {
        self.lblSTitle.text = self.appData?.appStoreChoiceTitle
        self.lblTitle.text = self.appData?.appRelatedTitle
        self.lblSubTitle.text = self.appData?.subTitle
        
        self.lblAppName.forEach { lbl in
            lbl.text = self.appData?.appName
        }
        
        self.lblAppTitle.forEach { lbl in
            lbl.text = self.appData?.appSubtitle
        }
        
        if self.viewGradient.layer.sublayers?.isEmpty ?? true { // Check if gradient layer already exists
            viewGradient.gradientBackground(from: .clear, to: .black.withAlphaComponent(0.35), direction: .topToBottom)
        }
        
        self.lblDescription1.text = self.appData?.appLongDescription
        self.lblDescription2.text = self.appData?.appLongDescription
        let linesAbout = self.lblDescription1.calculateMaxLines()
        self.lblDescription1Height.constant = Double(21 * linesAbout)
        self.lblDescription2Height.constant = Double(21 * linesAbout)
       
    }
    
    @IBAction func getAppAction(_ sender: UIButton) {
        self.getAppClosure?(true)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        self.shareClosure?(true)
    }
 
    @IBAction func closeAction(_ sender: UIButton) {
        self.closeClosure?(true)
    }
    
    
}

