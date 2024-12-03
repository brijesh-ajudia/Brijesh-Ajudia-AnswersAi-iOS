//
//  CardTVCell.swift
//  DemoAnswersAi
//
//  Created by Brijesh Ajudia on 02/12/24.
//

import UIKit

class CardTVCell: UITableViewCell {

    @IBOutlet weak var imgCover: UIImageView!
    
    @IBOutlet weak var viewGradient: UIView!
    
    @IBOutlet weak var lblSTitle: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var imgAppLogo: UIImageView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var lblAppTitle: UILabel!
    
    @IBOutlet weak var btnGet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            self.viewGradient.gradientBackground(from: .clear, to: .black.withAlphaComponent(0.35), direction: .topToBottom)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


