//
//  CoctailCell.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//
//

import UIKit

final class CoctailCell: UICollectionViewCell {
    static let resuseID = "CoctailCell"
    
    private let coctailNameLabel = UILabel()
    private let ingridientsLabel = UILabel()
    private let instructionLabel = UILabel()
    private let stack = UIStackView()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUIElements(){
        configLabel(label: coctailNameLabel, sizeText: 18, weithText: .bold, lines: 1, alignment: .left, color: .black)
        configLabel(label: ingridientsLabel, sizeText: 16, weithText: .regular, lines: 2, alignment: .left, color: .black)
        configLabel(label: instructionLabel, sizeText: 12, weithText: .regular, lines: 3, alignment: .left, color: .black)
        configStack(stack: stack)
    }
    
    private func configStack(stack: UIStackView){
        stack.alignment = .center
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
    }
}

//MARK: - Configure Cell UI
extension CoctailCell{
    func configCell(nameCoctail: String, instruction: String, ingridients: [String]){
        coctailNameLabel.text = nameCoctail
        instructionLabel.text = instruction
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
        
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        
            stack.topAnchor.constraint(equalTo: backView.topAnchor, constant: 6),
            stack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -6),
            stack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -6),
            stack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 4),
        ])
    }
}

