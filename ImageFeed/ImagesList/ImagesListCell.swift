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
    weak var delegate: ImagesListCellDelegate?
    
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
    
    private func updateLikeButton() {
        let imageName = isLiked ? "Active" : "No Active"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
// MARK: - Public methods
    func configure(with photo: Photo, using dateFormatter: DateFormatter) {
        cellImage.contentMode = .center
        dateLabel.text = photo.createdAt.map { dateFormatter.string(from: $0) } ?? ""
        setIsLiked(photo.isLiked)
        let placeholderImage = UIImage(named: "placeholderImage")
        
        if let url = URL(string: photo.thumbImageURL) {
            cellImage.kf.setImage(with: url,
                                  placeholder: placeholderImage,
                                  options: [.transition(.fade(0.2))]) { result in
                switch result {
                case .success(let imageResult):
                    self.likeButton.isHidden = false
                    self.dateLabel.isHidden = false
                    self.cellImage.contentMode = .scaleAspectFill
                    self.cellImage.image = imageResult.image
                case .failure:
                    self.cellImage.contentMode = .center
                    self.likeButton.isHidden = true
                    self.dateLabel.isHidden = true
                }
            }
        }
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
// MARK: - Private methods
    private func setupView() {
        [cellImage, likeButton, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
}
