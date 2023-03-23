//
//  PlayerDetailViewController.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 22/03/23.
//

import UIKit
import Combine
import SDWebImage

class PlayerDetailViewController: UIViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var positionName: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var mainPositionLabel: UILabel!
    @IBOutlet weak var preferredFootLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    var viewModel: PlayerDetailViewModel?
    var cancelables = Set<AnyCancellable>()
    
    enum IndicatorType: String {
        case age = "Age"
        case dateOfBirth = "Date of birth"
        case height = "Height"
        case weight = "Weight"
        case nationality = "Nationality"
        case marketPrice = "Market price"
        case preferredFoot = "Preferred foot"
        case mainPosition = "Main position"
        case playerNumber = "Player number"
        case rating = "Rating"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        setupPlayerDetailViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        aboutView.layer.borderColor = UIColor.lightGray.cgColor
        aboutView.layer.borderWidth = 0.5
    }
    
    func setupPlayerDetailViewModel() {
        viewModel = PlayerDetailViewModel()
        viewModel?.showError = { [weak self] message in
            self?.showAlert(title: StringConstant.alert, message: message)
        }
        viewModel?.displayLoader = { [weak self] value in
            DispatchQueue.main.async {
                self?.showActivityIndicator(value: value)
            }
        }
        viewModel?.$playerDetail
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] data in
                self?.loadDataOnScreen()
            })
            .store(in: &cancelables)
    }
    
    func showActivityIndicator(value: Bool) {
        loader.isHidden = !value
        value ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func configureView(with slug: String) {
        print("selected slug \(slug)")
        guard Reachability.isConnectedToNetwork() else {
            showAlert(title: StringConstant.alert, message: StringConstant.networkAlert)
            return
        }
        DispatchQueue.main.async {
            self.viewModel?.gatherPlayerInformation(slug: slug)
        }
    }
    
    func loadDataOnScreen() {
        guard let playerDetail = viewModel?.playerDetail?.data else {
            return
        }
        playerImageView.sd_setImage(with: URL(string: playerDetail.player_photo))
        teamImageView.sd_setImage(with: URL(string: playerDetail.team_photo))
        playerNameLabel.text = playerDetail.player_name
        teamNameLabel.text = playerDetail.team_name
        countryName.text = playerDetail.player_country
        aboutLabel.text = playerDetail.about
        
        for indicator in playerDetail.indicators {
            let indicatorType = IndicatorType(rawValue: indicator.key)
            switch indicatorType {
            case .age:
                ageLabel.text = indicator.value
            case .dateOfBirth:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let date = dateFormatter.date(from: indicator.value) {
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    dateOfBirthLabel.text = dateFormatter.string(from: date)
                }
            case .height:
                heightLabel.text = indicator.value
            case .weight:
                weightLabel.text = indicator.value
            case .nationality:
                nationalityLabel.text = indicator.value
            case .marketPrice:
                marketPriceLabel.text = indicator.value
            case .preferredFoot:
                preferredFootLabel.text = indicator.value
            case .mainPosition:
                positionName.text = indicator.value
                mainPositionLabel.text = indicator.value
            case .playerNumber:
                numberLabel.text = indicator.value
            case .rating:
                ratingLabel.text = indicator.value
            default:
                break
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
