//
//  Utils.swift
//  DemoAnswersAi
//
//  Created by Brijesh Ajudia on 02/12/24.
//

import Foundation
import UIKit

class Utils {
    
    static let shared: Utils = {
        let instance = Utils()
        return instance
    }()
    
    class func loadVC(strStoryboardId: String, strVCId: String) -> UIViewController {
        let vc = getStoryboard(storyboardName: strStoryboardId).instantiateViewController(withIdentifier: strVCId)
        return vc
    }
    
    class func getStoryboard(storyboardName: String) -> UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
    
    class func showToastMessage(title:String, messageColor: UIColor = UIColor.white, backGoundColor: UIColor = UIColor.black) {
        DispatchQueue.main.async {
            if let toastView = sceneDelegate?.window?.viewWithTag(2532515){
                toastView.removeFromSuperview()
            }
            
            var style: ToastStyle = ToastManager.shared.style
            style.messageColor = messageColor
            style.backgroundColor = backGoundColor
           // style.backgroundColor = UIColor.ToastColor!
            UIApplication.topViewController()?.view.makeToast(title, duration: 2.5, position: .bottom, style: style)
            ToastManager.shared.isTapToDismissEnabled = true
        }
    }
    
}

extension UISheetPresentationController.Detent {
    static func customDetent(height: CGFloat) -> UISheetPresentationController.Detent {
        if #available(iOS 16.0, *) {
            return UISheetPresentationController.Detent.custom(identifier: .init(rawValue: "customHeight")) { context in
                return height
            }
        } else {
            return UISheetPresentationController.Detent.medium()
        }
    }
}

class DeviceUtility {
    static var deviceHasTopNotch: Bool {
        if #available(iOS 11.0,  *) {
            return sceneDelegate?.window?.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let sceneDelegate = windowScene?.delegate as? SceneDelegate

public func screenWidth() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.width
}

public func screenHeight() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.height
}

struct StoryBoard {
    static let SB_MAIN = "Main"
}

struct ViewControllerID {
    //LOGIN
    static let VC_Main = "MainViewController"
    static let VC_CardDetails = "CardDetailsVC"
    
}
