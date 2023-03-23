//
//  PlayersServiceManager.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation

typealias playerCompletionHandler = Result<Player, CustomError>

protocol PlayerServiceProtocol {
    func getPlayerList(completion: @escaping(playerCompletionHandler) -> Void)
}

class PlayersServiceManager {
    
    let httpsClient: HTTPSClient
    
    init(client: HTTPSClient = HTTPSClient()) {
        self.httpsClient = client
    }
    
    func playerListRequest() -> URLRequest? {
        guard let url = URL(string: URLConstant.baseURL + URLConstant.players) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.rawValue
        return request
    }
}

extension PlayersServiceManager: PlayerServiceProtocol {
    
    func getPlayerList(completion: @escaping(playerCompletionHandler) -> Void) {
        guard let urlRequest = playerListRequest() else {
            completion(.failure(.invalidRequest))
            return
        }
        httpsClient.execute(with: urlRequest, completion: completion)
    }
}
