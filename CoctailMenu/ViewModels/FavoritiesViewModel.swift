//
//  FavoritiesViewModel.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import Foundation

protocol FavoritiesViewModelProtocol{
    var favoritiestPublisher: Published<[FavorCotail]>.Publisher { get }
    var favorities: [FavorCotail] { get }
    func getSaveCoctails()
    func deleteOneItem(nameCoctail: String)
    func deleteAllFavs() 
}

final class FavoritiesViewModel: FavoritiesViewModelProtocol{

    @Published var favorities: [FavorCotail] = .init()
    var favoritiestPublisher: Published<[FavorCotail]>.Publisher{ $favorities }
    private let storeManager: StoreManagerProtocol
    
    init(storeManager: StoreManagerProtocol) {
        self.storeManager = storeManager
    }
    
    func getSaveCoctails(){
        favorities = storeManager.fetchCoctails()
        print("Favorities viewMode \(favorities)")
    }
    
    func deleteAllFavs(){
        storeManager.deleteAllCoctails()
        fetchCoctails()
    }
    
    func deleteOneItem(nameCoctail: String){
        storeManager.deleteOneCoctails(withName: nameCoctail)
        fetchCoctails()
    }
    
    private func fetchCoctails(){
        favorities = storeManager.fetchCoctails()
    }
}
