//
//  MainViewmodel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation
import Combine

protocol MainViewModelProtocol{
    var isLoadedPublisher: Published<Bool>.Publisher { get }
    var selectedIndexPathPublisher: Published<IndexPath>.Publisher { get }
    var indexPathCurentPublisher: Published<IndexPath>.Publisher { get }
    var selectedIndexPath: IndexPath { get set }
    var indexPathCurent: IndexPath { get set }
    var favoritiesPublisher: Published<[CoctailModel : Bool]>.Publisher { get }
    var favorities: [CoctailModel : Bool] { get }
    var changeColorWhenReload: Bool { get set}
    var dataCoctailsForSections: [ListSectionModel] { get }
    func handleCellEvent(coctail: CoctailModel, event: CoctailCellEvent)
    func getCoctailData(searchWord: String)
    func getIngridientsData(ingridient: String)
    func checkFavorities()
}

final class MainViewModel: MainViewModelProtocol{
    @Published var isLoaded: Bool = false
    @Published var selectedIndexPath: IndexPath = .init()
    @Published var indexPathCurent: IndexPath = .init()
    @Published var favorities: [CoctailModel : Bool] = .init()
    
    var isLoadedPublisher: Published<Bool>.Publisher { $isLoaded }
    var selectedIndexPathPublisher: Published<IndexPath>.Publisher { $selectedIndexPath }
    var indexPathCurentPublisher: Published<IndexPath>.Publisher { $indexPathCurent }
    var favoritiesPublisher: Published<[CoctailModel : Bool]>.Publisher { $favorities }
    
    var changeColorWhenReload: Bool = false
    var dataCoctailsForSections: [ListSectionModel] = .init()
   
    private let network: NetworkMangerProtocol
    private let storeManager: StoreManagerProtocol
    
    init(network: NetworkMangerProtocol, store: StoreManagerProtocol){
        self.network = network
        self.storeManager = store
        addIngridienstForSection()
        getIngridientsData(ingridient: "Vodka")
    }
    
    func getCoctailData(searchWord: String){
        let searcWord = searchWord.lowercased()
        let request = CoctailRequest(cotailName: searcWord, ingridients: nil, paramToChoose: .coctailName)
         fetchCoctailData(request: request)
    }
    
    func getIngridientsData(ingridient: String){
        let request = CoctailRequest(cotailName: nil, ingridients: ingridient, paramToChoose: .ingridients)
         fetchCoctailData(request: request)
    }
    
    func handleCellEvent(coctail: CoctailModel, event: CoctailCellEvent) {
        switch event {
        case .favoriteDidTapped:
            favorities[coctail] = !(favorities[coctail] ?? false) //если нет значения то ?? вернет false и favorities[coctail] = !false то есть true
            if favorities[coctail] == true {
                saveCoctail(coctailData: coctail)
            } else {
                deleteOneCoctail(coctailData: coctail)
                //print(storeManager.fetchCoctails())
            }
        }
    }
    
    func checkFavorities(){
        let savedCoctail = storeManager.fetchCoctails()
        let namesCoctails = savedCoctail.map { $0.nameCoctail }
        favorities.forEach { key, value in
            if !namesCoctails.contains(key.name){
                favorities[key] = false
            }
        }
    }
    
    private func saveCoctail(coctailData: CoctailModel){
        let ingridientsString = coctailData.ingredients.joined(separator: ",")
        storeManager.createFavoriteCoctail(coctailName: coctailData.name, ingridients: ingridientsString, instruction: coctailData.instructions)
    }
    
    private func deleteOneCoctail(coctailData: CoctailModel){
        storeManager.deleteOneCoctails(withName: coctailData.name)
    }
        
    private func addIngridienstForSection(){
        dataCoctailsForSections.append(.ingridients(IngridiensModel.getIngridients()))
    }
    
    private func checkDataCoctailsForSections(){
        if dataCoctailsForSections.count > 1{
            dataCoctailsForSections.removeLast()
        }
    }
    
    private func fetchCoctailData(request: CoctailRequest){
        isLoaded = false
        Task{ @MainActor in
            do{
                checkDataCoctailsForSections()
                let dataCoctailOrIngredient = try await network.request(request)
                dataCoctailsForSections.append(.coctailData(dataCoctailOrIngredient))
                isLoaded = true
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
