//
//  ViewController.swift
//  DemoAnswersAi
//
//  Created by Brijesh Ajudia on 02/12/24.
//

import UIKit

struct AppData: Codable {
    let appStoreChoiceTitle: String
    let appRelatedTitle: String
    let subTitle: String
    let appLogo: String
    let appName: String
    let appSubtitle: String
    let appLongDescription: String
}

struct AppList: Codable {
    let apps: [AppData]
}


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var apps: [AppData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(cellType: CardTVCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let loadedApps = loadAppData() {
            apps = loadedApps
            self.tblView.reloadData()
        }
    }
    
    func loadAppData() -> [AppData]? {
        guard let url = Bundle.main.url(forResource: "Apps", withExtension: "json") else {
            print("File not found.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let appList = try decoder.decode(AppList.self, from: data)
            return appList.apps
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTVCell", for: indexPath) as! CardTVCell
        
        let appData = self.apps[indexPath.row]
        
        cell.lblSTitle.text = appData.appStoreChoiceTitle
        cell.lblTitle.text = appData.appRelatedTitle
        cell.lblSubTitle.text = appData.subTitle
        cell.lblAppName.text = appData.appName
        cell.lblAppTitle.text = appData.appSubtitle
        
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 476 + 20
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let expandedVC = Utils.loadVC(strStoryboardId: StoryBoard.SB_MAIN, strVCId: ViewControllerID.VC_CardDetails) as! CardDetailsVC
        expandedVC.modalPresentationStyle = .fullScreen
        let appData = self.apps[indexPath.row]
        expandedVC.appData = appData
        
        present(expandedVC, animated: true, completion: nil)
    }
}
