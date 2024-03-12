//
//  MainViewmodel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation

final class MainViewModel{
    
    @Published var isLoaded: Bool = false
    @Published var dataCoctailsForSections: [ListSectionModel] = .init()
    private let network: NetworkMangerProtocol = NetworkManager()
    
    init(){
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
    
    func removeSection(){
        dataCoctailsForSections.removeLast()
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
