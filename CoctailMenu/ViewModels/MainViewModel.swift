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
    var serchTextPublisher: Published<String>.Publisher { get }
    var selectedIndexPathPublisher: Published<IndexPath>.Publisher { get }
    var indexPathCurentPublisher: Published<IndexPath>.Publisher { get }

    var serchText: String { get set }
    var selectedIndexPath: IndexPath { get set }
    var indexPathCurent: IndexPath { get set }
    
    var changeColorWhenReload: Bool { get set}
    var dataCoctailsForSections: [ListSectionModel] { get }
    func getCoctailData(searchWord: String)
    func getIngridientsData(ingridient: String)
    
}

final class MainViewModel: MainViewModelProtocol{
    @Published var isLoaded: Bool = false
    @Published var serchText: String = ""
    @Published var selectedIndexPath: IndexPath = .init()
    @Published var indexPathCurent: IndexPath = .init()
    var isLoadedPublisher: Published<Bool>.Publisher { $isLoaded }
    var serchTextPublisher: Published<String>.Publisher { $serchText }
    var selectedIndexPathPublisher: Published<IndexPath>.Publisher { $selectedIndexPath }
    var indexPathCurentPublisher: Published<IndexPath>.Publisher { $indexPathCurent }
    var dataCoctailsForSections: [ListSectionModel] = .init()
    var changeColorWhenReload: Bool = false
    private let network: NetworkMangerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(network: NetworkMangerProtocol){
        self.network = network
        observe()
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
    
    private func observe(){
        $serchText
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else {return}
                print("searchtext ViewModel \(text)")
            }
            .store(in: &cancellables)
        
        $selectedIndexPath
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else {return}
                print("Done path")
            }
            .store(in: &cancellables)
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
