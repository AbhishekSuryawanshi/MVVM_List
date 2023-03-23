//
//  PlayerViewModel.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation

class PlayerViewModel: ObservableObject {
    
    let service: PlayerServiceProtocol
    @Published private(set) var playerData: Player?
    
    var showError: ((String) -> ())?
    var displayLoader: ((Bool) -> ())?
    
    init(service: PlayerServiceProtocol = PlayersServiceManager()) {
        self.service = service
    }
    
    func gatherPlayersList() {
        displayLoader?(true)
        service.getPlayerList() { [weak self] result in
            self?.displayLoader?(false)
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showError?(error.description)
                }
            case .success(let model):
                DispatchQueue.main.async {
                    self?.playerData = model
                }
            }
        }
    }
    
}
