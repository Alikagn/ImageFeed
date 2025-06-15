//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 21.03.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    private let showSingleShowImageSegueIdentifier = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol = ImagesListPresenter()
    @IBOutlet private weak var tableView: UITableView!
    
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        return formatter
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleShowImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            // Начало здесь!!!
            guard let photo = presenter.photo(at: indexPath.row) else { return }
            viewController.imageURL = URL(string: photo.largeImageURL)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func performBatchUpdates(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPath = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPath, with: .automatic)
        } completion: { _ in }
    }
    
    func showLikeAlert(_ error: any Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showImageAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Некорректная ссылка на изображение",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let placeholderPhoto = UIImage(named: "placeholder_photo")
        guard let photo = presenter.photo(at: indexPath.row) else { return }
        
        cell.cellImage.image =  placeholderPhoto
        
        cell.cellImage.kf.indicatorType = .activity
        
        if let url = URL(string: photo.thumbImageURL) {
            cell.cellImage.kf.setImage(with: url)
        }
        
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        
        let likeImage = photo.isLiked ? "Active" : "No Active"
        cell.likeButton.setImage( UIImage(named: likeImage), for: .normal)
    }
    
    func updateTableViewAnimated() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleShowImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter.photo(at: indexPath.row) else { return 0 }
        return presenter.calculateCellHeight(for: photo, tableViewWidth: tableView.bounds.width)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ProcessInfo.processInfo.arguments.contains("UITEST") {
            return
        }
        
        if indexPath.row == presenter.photosCount - 1 {
            presenter.fetchPhotosNextPageIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}


// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let photo = presenter.photo(at: indexPath.row) else { return }
        
        presenter.changeLike(for: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let newPhoto = self?.presenter.photo(at: indexPath.row) {
                        cell.setIsLiked(newPhoto.isLiked)
                    }
                case .failure(let error):
                    self?.showLikeAlert(error)
                    cell.setIsLiked(photo.isLiked)
                }
            }
        }
        
    }
}
