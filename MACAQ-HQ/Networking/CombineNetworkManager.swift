//
//  NetworkManager.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/13/22.
//

import Foundation
import Combine

class NetworkManagerCombine {
    
    func fetchData<T : Codable>(_ model : T.Type,from url: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            fatalError()
        }
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map({ data, response in
                return data
            })
            .decode(type: model, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
}
