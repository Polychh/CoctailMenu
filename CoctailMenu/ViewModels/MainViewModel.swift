//
//  MainViewmodel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation

protocol MainViewModelProtocol{
    var isLoadedPublisher: Published<Bool>.Publisher { get }
    var dataCoctailsForSections: [ListSectionModel] { get }
    func getCoctailData(searchWord: String)
    func getIngridientsData(ingridient: String)
}

final class MainViewModel: MainViewModelProtocol{
    @Published var isLoaded: Bool = false
    var isLoadedPublisher: Published<Bool>.Publisher { $isLoaded }
    var dataCoctailsForSections: [ListSectionModel] = .init()
    private let network: NetworkMangerProtocol
    
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
