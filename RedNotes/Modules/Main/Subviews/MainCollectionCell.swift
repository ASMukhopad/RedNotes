//
//  MainCollectionCell.swift
//  RedNotes
//
//  Created by Alexander on 02.03.2023.
//

import UIKit

final class MainCollectionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Times New Roman", size: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return titleLabel
    }()
    
    private let dateLabel: UILabel = {
        var dateLabel = UILabel()
        dateLabel.font = UIFont(name: "Times New Roman", size: 12)
        dateLabel.alpha = 0.4
        return dateLabel
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configure(with title: String?,
                   _ date: String?) {
        titleLabel.text = title
        dateLabel.text = date
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.centerY)
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY).inset(2)
            make.bottom.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
