//
//  MainViewmodel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation

final class MainViewModel{
    
    @Published var dataCoctail:  CoctailData = .init()
    @Published var isLoaded: Bool = false
    private let network: NetworkMangerProtocol = NetworkManager()
    
    init(){
        //fetchCoctailData()
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
                dataCoctail = []
                dataCoctail = try await network.request(request)
                isLoaded = true
                print("done")
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
