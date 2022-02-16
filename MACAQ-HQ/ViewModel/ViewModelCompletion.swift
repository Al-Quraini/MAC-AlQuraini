//
//  ViewModelCompletion.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/16/22.
//

import Foundation


class ViewModelCompletion {
    
    private let networkManagerCompletion = NetworkManagerCompletion()
    
    func getProductionCompanies(_ id : Int, completion : @escaping ([ProductionCompany]) -> Void){
        let productionUrl = "\(NetworkURLs.productionUrl)\(id)?\(NetworkURLs.apiKey)"
        print(productionUrl)
        networkManagerCompletion.performRequest(ProductionModel.self, from: productionUrl) { result in
            switch result {
                case .success(let response):
                   completion(response.productionCompanies)
                
                case .failure(let error):
                    print(error.localizedDescription)
                completion([])
                        }
                    }
        }
    
    
    

}
