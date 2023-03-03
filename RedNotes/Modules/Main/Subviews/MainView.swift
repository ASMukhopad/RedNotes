//
//  MainView.swift
//  RedNotes
//
//  Created by Alexander on 02.03.2023.
//

import UIKit

// MARK: - MainViewProtocol

protocol MainViewProtocol: AnyObject {
    var notesItemsCount: Int { get }
    
    func selectItem(with index: Int)
    
    func getText(with index: Int) -> String
    func getDate(with index: Int) -> String
}

final class MainView: UIView {
    
    // MARK: - Internal Properties
    
    lazy var collectionView: UICollectionView = {
        var collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: compositionalLayout())
        collection.register(registerClass: MainCollectionCell.self)
        return collection
    }()
    
    weak var delegate: MainViewProtocol?
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        addSubview(collectionView)
        
        setupCollection()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func compositionalLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(70)
            ),
            repeatingSubitem: NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            ),
            count: 1
        )
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(
            section: section,
            configuration: config
        )
        return layout
    }
    
    private func setupCollection() {
        collectionView.backgroundColor = .systemGray6
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.notesItemsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: delegate?.getText(with: indexPath.item),
                       delegate?.getDate(with: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MainView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectItem(with: indexPath.item)
    }
}
