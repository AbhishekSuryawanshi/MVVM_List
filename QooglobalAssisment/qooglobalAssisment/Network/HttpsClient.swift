//
//  HttpsClient.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation

protocol HTTPSClientProtocol {
    func execute<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, CustomError>) -> Void)
}

class HTTPSClient: HTTPSClientProtocol {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, CustomError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let res = response as? HTTPURLResponse,
                  200..<400 ~= res.statusCode else {
                completion(.failure(.general(message: "response failed with other than")))
                return
            }
            
            guard error == nil else {
                completion(.failure(.general(message: error?.localizedDescription ?? "something went wring")))
                return
            }
            
            guard let responseData = data, responseData.isEmpty == false else {
                completion(.failure(.general(message: "response failed with other than")))
                return
            }
            
            do {
                print(try JSONSerialization.jsonObject(with: responseData))
                let model = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(model))
            } catch{
                completion(.failure(.general(message: error.localizedDescription)))
            }
        }
        task.resume()
    }
    
}


//let json = (try? JSONSerialization.jsonObject(with: data, options: []))
