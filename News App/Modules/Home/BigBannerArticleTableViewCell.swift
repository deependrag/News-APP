//
//  BigBannerArticleTableViewCell.swift
//  News App
//
//  Created by Deependra Dhakal on 08/12/2020.
//

import UIKit
import SDWebImage

class BigBannerArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    
    @IBOutlet weak var sourceView: UIView! {
        didSet {
            sourceView.layer.cornerRadius = 4
            sourceView.clipsToBounds = true
        }
    }
    
    lazy var gradientLayer : CAGradientLayer = {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor,
                           UIColor.black.withAlphaComponent(1.0).cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    

    @IBOutlet weak var gradientBGView: UIView! {
        didSet {
            gradientLayer.frame = gradientBGView.bounds
            gradientBGView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(model: Articles?) {
        self.titleLabel.text = model?.title
        self.sourceLabel.text = model?.source?.name
        self.newsImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.newsImageView.sd_setImage(with: URL(string: model?.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
        
        if let localDate = model?.publishedAt?.convertToLocalDate() {
            self.dateLabel.text = localDate.timeAgoDisplay()
        }else {
            self.dateLabel.text = ""
        }
    }
    
}
