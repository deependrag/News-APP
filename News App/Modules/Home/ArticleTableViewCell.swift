//
//  ArticleTableViewCell.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView! {
        didSet {
            newsImageView.layer.cornerRadius = 8
            newsImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var sourceView: UIView! {
        didSet {
            sourceView.layer.cornerRadius = 4
            sourceView.clipsToBounds = true
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
        self.descriptionLabel.text = model?.description
        self.sourceLabel.text = model?.source?.name
        self.newsImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.newsImageView.sd_setImage(with: URL(string: model?.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
        self.dateLabel.text = model?.publishedAt?.parseDate()
    }
    
}
