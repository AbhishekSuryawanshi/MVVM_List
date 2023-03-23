//
//  PlayerViewController.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import UIKit
import Combine
import SDWebImage

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var topPlayersCollectionView: UICollectionView!
    @IBOutlet weak var allPlayerView: UIView!
    @IBOutlet weak var allPlayersTableView: UITableView!
    
    var viewModel: PlayerViewModel?
    var cancelables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        loader.isHidden = true
        super.viewDidLoad()
        setupPlayerViewModel()
        makeNetworkCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allPlayerView.layer.borderWidth = 0.5
        allPlayerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupPlayerViewModel() {
        viewModel = PlayerViewModel()
        viewModel?.showError = { [weak self] message in
            self?.showAlert(title: StringConstant.alert, message: message)
        }
        viewModel?.displayLoader = { [weak self] value in
            DispatchQueue.main.async {
                self?.showActivityIndicator(value: value)
            }
        }
        viewModel?.$playerData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] player in
                self?.topPlayersCollectionView.reloadData()
                self?.allPlayersTableView.reloadData()
            })
            .store(in: &cancelables)
    }
    
    func showActivityIndicator(value: Bool) {
        loader.isHidden = !value
        value ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func makeNetworkCall() {
        guard Reachability.isConnectedToNetwork() else {
            showAlert(title: StringConstant.alert, message: StringConstant.networkAlert)
            return
        }
        DispatchQueue.main.async {
            self.viewModel?.gatherPlayersList()
        }
    }
    
}

extension PlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.playerData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let playerData = viewModel?.playerData?.data[indexPath.item] else {
            return TopPlayersCollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topPlayerCell", for: indexPath) as! TopPlayersCollectionViewCell
        cell.playerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.playerImageView.sd_setImage(with: URL(string: playerData.photo))
        cell.playerNameLabel.text = playerData.name
        cell.teamNameLabel.text = playerData.teamName
        
        cell.topPlayersImageBackView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.topPlayersImageBackView.layer.shadowOpacity = 0.5
        cell.topPlayersImageBackView.layer.shadowRadius = 2
        cell.topPlayersImageBackView.layer.masksToBounds = false
        cell.topPlayersImageBackView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let playerData = self.viewModel?.playerData?.data[indexPath.item],
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PlayerDetailViewController") as? PlayerDetailViewController else {
            return
        }
        viewController.configureView(with: playerData.slug)
        self.present(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.5 - 1, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


extension PlayerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.playerData?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let playerData = viewModel?.playerData?.data[indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "allPlayersCell", for: indexPath) as! AllPlayersTableViewCell
        cell.nameLabel.text = playerData.name
        cell.playerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.playerImageView.sd_setImage(with: URL(string: playerData.photo))
        cell.teamNameLabel.text = playerData.teamName
        cell.positionNameLabel.text = playerData.positionName
        cell.ratingLabel.text = playerData.rating
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let playerData = self.viewModel?.playerData?.data[indexPath.row],
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PlayerDetailViewController") as? PlayerDetailViewController else {
            return
        }
        viewController.configureView(with: playerData.slug)
        self.present(viewController, animated: true)
    }
}
