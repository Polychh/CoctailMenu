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
    private let storeManager: StoreManagerProtocol = StoreManager()
    
    init(network: NetworkMangerProtocol){
        self.network = network
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
                let ingridientsString = coctail.ingredients.joined(separator: ",")
                storeManager.createFavoriteCoctail(coctailName: coctail.name, ingridients: ingridientsString, instruction: coctail.instructions)
            } else {
                print("UNSave")
            }
        }
    }

//   func handleCellEvent(coctail: CoctailModel, event: CoctailCellEvent) {
//      switch event {
//      case .favoriteDidTapped:
//        if let value = favorities[coctail] {
//          favorities[coctail] = !value
//        } else {
//            favorities[coctail] = true
//        }
//          if favorities[coctail] == true{
//              print("Save")
//          } else {
//              print("UNSave")
//          }
//      }
//    }
        
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
