//
//  PlayerDetailViewModel.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 22/03/23.
//

import Foundation

class PlayerDetailViewModel {
    
    var showError: ((String) -> ())?
    var displayLoader: ((Bool) -> ())?

    @Published private(set) var playerDetail: PlayerDetail?
    let service: PlayerDetailServiceProtocol
    
    init(service: PlayerDetailServiceProtocol = PlayerDetailServiceManager()) {
        self.service = service
    }
    
    func gatherPlayerInformation(slug: String) {
        displayLoader?(true)
        service.getPlayerDetail(slug: slug) { [weak self] result in
            self?.displayLoader?(false)
            switch result {
            case .failure(let error):
                self?.showError?(error.description)
            case .success(let detail):
                DispatchQueue.main.async {
                    self?.playerDetail = detail
                }
            }
        }
    }
    
}
