//
//  CoctailCell.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//
//

import UIKit
import Combine
enum CoctailCellEvent {
  case favoriteDidTapped
}

final class CoctailCell: UICollectionViewCell {
    static let resuseID = "CoctailCell"
    
    private let eventSubject = PassthroughSubject<CoctailCellEvent, Never>()
      var eventPublisher: AnyPublisher<CoctailCellEvent, Never> {
        eventSubject.eraseToAnyPublisher()
      }
    
    var cancellables = Set<AnyCancellable>()
    
    private let coctailNameLabel = UILabel()
    private let ingridientsLabel = UILabel()
    private let instructionLabel = UILabel()
    private let stack = UIStackView()
    private let favoriteButton = UIButton()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1).cgColor
        view.layer.cornerRadius = 15
        view.clipsToBounds = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIElements()
        setConstrains()
        addActionButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUIElements(){
        configLabel(label: coctailNameLabel, sizeText: 18, weithText: .bold, lines: 1, alignment: .left, color: .black)
        configLabel(label: ingridientsLabel, sizeText: 16, weithText: .regular, lines: 3, alignment: .left, color: .black)
        configLabel(label: instructionLabel, sizeText: 12, weithText: .regular, lines: 5, alignment: .left, color: .black)
        configButton(button: favoriteButton, symbol: "star.fill")
        configStack(stack: stack)
    }
    
    func configButton(button: UIButton, symbol: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1)
    }
    
    private func configStack(stack: UIStackView){
        stack.alignment = .leading
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.spacing = 5
    }
    
    private func configLabel(label: UILabel, sizeText: CGFloat, weithText: UIFont.Weight, lines: Int, alignment: NSTextAlignment, color: UIColor){
        label.textAlignment = alignment
        label.textColor = color
        label.numberOfLines = lines
        label.font = .systemFont(ofSize: sizeText, weight: weithText)
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true // Enable font size adjustment
        label.minimumScaleFactor = 0.8 // Set the minimum scale factor
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coctailNameLabel.text = nil
        ingridientsLabel.text = nil
        instructionLabel.text = nil
        cancellables = Set<AnyCancellable>()
    }
    
    private func addActionButtons(){
        favoriteButton.addTarget(nil, action: #selector(favoriteTapped), for: .touchUpInside)
    }
    
    @objc func favoriteTapped(){
        eventSubject.send(.favoriteDidTapped)
    }
}

//MARK: - Configure Cell UI
extension CoctailCell{
    func configCell(nameCoctail: String, instruction: String, ingridients: [String], isLiked: Bool){
        coctailNameLabel.text = nameCoctail
        instructionLabel.text = instruction
        let image: UIImage? = isLiked ? .init(systemName: "heart.fill"): .init(systemName: "heart")
        favoriteButton.setBackgroundImage(image, for: .normal)
        let ingridientsString = ingridients.joined(separator: ",")
        ingridientsLabel.text = ingridientsString
    }
}

//MARK: - Constrains
extension CoctailCell{
    private func setConstrains(){
        contentView.addSubview(backView)
        stack.addArrangedSubview(coctailNameLabel)
        stack.addArrangedSubview(ingridientsLabel)
        stack.addArrangedSubview(instructionLabel)
        backView.addSubview(stack)
        backView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            favoriteButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -5),
            favoriteButton.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 20),
                        
            stack.topAnchor.constraint(equalTo: backView.topAnchor, constant: 6),
            stack.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -2),
            stack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -6),
            stack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 4),
        ])
    }
}

