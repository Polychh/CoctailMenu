//
//  MainViewmodel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation

final class MainViewModel{
    
    @Published var dataCoctail:  CoctailData = .init()
    private let network: NetworkMangerProtocol = NetworkManager()
    
    init(){
        fetchCoctailData()
    }
    
    private func fetchCoctailData(){
        let request = CoctailRequest(cotailName: nil, ingridients: "vodka", paramToChoose: .ingridients)
        Task{ @MainActor in
            do{
                dataCoctail = try await network.request(request)
                print("done")
            } catch{
                print(error.localizedDescription)
            }
        }
    }
}
