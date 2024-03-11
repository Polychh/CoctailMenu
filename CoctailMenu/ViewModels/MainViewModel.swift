//
//  MainViewmodel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation

final class MainViewModel{
    
    @Published var dataCoctail: [ListSectionModel] = []
    @Published var isLoaded: Bool = false
    private let network: NetworkMangerProtocol = NetworkManager()
    private var data: [CoctailModel] = .init()
    
    init(){
        dataCoctail.append(.ingridients(IngridiensModel.getIngridients()))
    }
    
    func getIngridientsData(searchWord: String){
        let searcWord = searchWord.lowercased()
        let request = CoctailRequest(cotailName: nil, ingridients: searcWord, paramToChoose: .ingridients)
         fetchCoctailData(request: request)
    }
    
    private func fetchCoctailData(request: CoctailRequest){
        isLoaded = false
        Task{ @MainActor in
            do{
                if dataCoctail.count > 1{
                    dataCoctail.removeLast()
                }
                data = []
                data = try await network.request(request)
                dataCoctail.append(.coctailData(data))
                isLoaded = true
                print("done")
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
