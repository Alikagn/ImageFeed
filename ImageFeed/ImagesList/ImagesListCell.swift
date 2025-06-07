//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 29.03.2025.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        isLiked.toggle()
        delegate?.imageListCellDidTapLike(self)
    }
    
    private var isLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    
    weak var delegate: ImagesListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.kf.indicatorType = .activity
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let placeholderImage = UIImage(named: "placeholderImage")
        cellImage.kf.cancelDownloadTask()
        cellImage.image = placeholderImage
    }
    
    func setIsLiked(_ liked: Bool) {
        isLiked = liked
    }
    
    func configure(with imageURL: URL?, liked: Bool, dateText: String?) {
        setIsLiked(liked)
        let placeholderImage = UIImage(named: "placeholderImage")
        
        if let url = imageURL {
            cellImage.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            cellImage.image = placeholderImage
        }
        
        dateLabel.text = dateText
    }
    
    private func updateLikeButton() {
        let imageName = isLiked ? "Active" : "No Active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
