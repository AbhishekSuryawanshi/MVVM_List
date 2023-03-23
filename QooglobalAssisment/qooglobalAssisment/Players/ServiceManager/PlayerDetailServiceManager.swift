//
//  PlayerDetailServiceManager.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation

typealias playerDetailCompletionHandler = Result<PlayerDetail, CustomError>

protocol PlayerDetailServiceProtocol {
    func getPlayerDetail(slug: String, completion: @escaping(playerDetailCompletionHandler) -> Void)
}

class PlayerDetailServiceManager {
    
    let httpClient: HTTPSClient
    
    init(client: HTTPSClient = HTTPSClient()) {
        self.httpClient = client
    }
    
    func playerDetailRequest(with slug: String) -> URLRequest? {
        guard let url = URL(string: URLConstant.baseURL + URLConstant.playerDetail) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        
        do {
            let parameter: [String: Any] = ["slug": slug]
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
            return request
        } catch {
            return nil
        }
    }
}

extension PlayerDetailServiceManager: PlayerDetailServiceProtocol {
    
    func getPlayerDetail(slug: String, completion: @escaping(playerDetailCompletionHandler) -> Void) {
        guard let urlRequest = playerDetailRequest(with: slug) else {
            completion(.failure(.invalidRequest))
            return
        }
        httpClient.execute(with: urlRequest, completion: completion)
    }
}
