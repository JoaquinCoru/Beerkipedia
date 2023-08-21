//
//  NetworkModel.swift
//  BeerApp
//
//  Created by Joaquín Corugedo Rodríguez on 18/8/23.
//

import Foundation
import Combine

enum NetworkError: Error, Equatable {
    case malformedURL
    case other
    case noData
    case errorCode(Int?)
    case decoding
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

final class NetworkModel {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getBeers(foodName: String? = nil, page: Int) -> AnyPublisher<[BeerModel], Error> {
        
        var parameters: [String: String] = ["page": String(describing: page)]
        
        if let foodName {
            parameters["food"] = foodName
        }
        
        let resultPublisher: AnyPublisher<[BeerModel], Error> = performRequestWithCombine("https://api.punkapi.com/v2/beers", httpMethod: .get, parameters: parameters)
        
        return resultPublisher
        
    }
}
private extension NetworkModel{
    
    func performRequestWithCombine <R: Codable> (_ urlString: String, httpMethod: HTTPMethod, parameters: [String: String]? = nil) -> AnyPublisher<R, Error> {
        
        var urlComponents = URLComponents(string: urlString)
        
        if let parameters {
            urlComponents?.queryItems = parameters.map({ (key, value) in
                URLQueryItem(name: key, value: value)
            })
        }
        
        guard let url = (urlComponents?.url) else {
            return Fail(error: NetworkError.malformedURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap{ guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else{
                throw URLError(.badServerResponse)
            }
                return $0.data
            }
            .decode(type: R.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func performNetworkRequest<R: Codable>(_ urlString: String, httpMethod: HTTPMethod, parameters: [String: String]? = nil, completion: @escaping (Result<R, NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(.malformedURL))
            return
        }
        
        if let parameters {
            urlComponents.queryItems = parameters.map({ (key, value) in
                URLQueryItem(name: key, value: value)
            })
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = try? JSONDecoder().decode(R.self, from: data) else {
                do{
                    print( try JSONSerialization.jsonObject(with: data))
                }catch{
                    print("error \(error.localizedDescription)")
                }
                
                completion(.failure(.decoding))
                return
            }
            completion(.success(response))
        }
        
        task.resume()
        
    }
}
