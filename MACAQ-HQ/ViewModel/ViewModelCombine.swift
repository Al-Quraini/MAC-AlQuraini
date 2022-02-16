//
//  ViewModel.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/13/22.
//

import Foundation
import Combine
import CoreData
import UIKit

class ViewModelCombine {
    
    static let shared = ViewModelCombine()
    
    private let networkManagerCombine = NetworkManagerCombine()
    private let networkManagerCompletion = NetworkManagerCompletion()

    private var cancellers = Set<AnyCancellable>()
    
    @Published var movies = [Movie]()
    @Published var movieIds = [Int]()
    
    func getMovies() {
        networkManagerCombine
            .fetchData(MovieModel.self,from: NetworkURLs.baseURL)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] response in
                self?.movies = response.results
            })
            .store(in: &cancellers)
    }
    
    func getProductionCompanies(_ id : Int, completion : @escaping ([ProductionCompany]) -> Void){
        let productionUrl = "\(NetworkURLs.productionUrl)\(id)/\(NetworkURLs.apiKey)"
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
    
    
    
    
    // core data view model
    
    // save movie
    func saveMovie(_ id : Int){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
        let context = appDelegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: "MovieData", in: context){
                let movieData = MovieData(entity: entity, insertInto: context)
                movieData.id = Int32(id)
                appDelegate.saveContext()
                fetchCoreData()
            }
        }
    }
    
    // display movie
     func fetchCoreData(){
        let fetch: NSFetchRequest = MovieData.fetchRequest()
               
               if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                   let context = appDelegate.persistentContainer.viewContext
                   
                   do {

                       let movies = try context.fetch(fetch)
                       let favourites = movies.map({Int($0.id)})
                       self.movieIds = favourites
                       
                   } catch let error {
                       print(error)
                   }
                   
               }
    }
    
    // delete movie from favourites
    func deleteData(_ id : Int){
        let fetch: NSFetchRequest = MovieData.fetchRequest()

               if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                   let context = appDelegate.persistentContainer.viewContext
                   
                   do {
                       let movies = try context.fetch(fetch)
                       let deletedItem = movies.first(where: {$0.id == id})
                       context.delete(deletedItem!)
                       appDelegate.saveContext()
                       fetchCoreData()
                       
                   } catch let error {
                       print(error)
                   }
                   
               }
    }
        
    
    func filterPost() {
        movies = []
    }
}
