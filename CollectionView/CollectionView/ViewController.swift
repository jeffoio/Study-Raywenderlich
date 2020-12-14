//
//  ViewController.swift
//  CollectionView
//
//  Created by TakHyun Jung on 2020/12/14.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDelegate {
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section,Int>!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = configureLayout()
        configureDataSource()
        collectionView.delegate = self
    }

    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: self.collectionView)  { (collectionView, indexPath, number ) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCell.reuseIdentifier, for: indexPath) as? NumberCell else { fatalError("Error Cell init")}
            cell.label.text = number.description
            if Int(number.description)! % 2 == 0 {
                cell.backgroundColor = .blue
            } else {
                cell.backgroundColor = .red
            }
            //cell.layer.cornerRadius = 15
            return cell
        }
        
        var initialSnapShot = NSDiffableDataSourceSnapshot<Section, Int>()
        initialSnapShot.appendSections([.main])
        initialSnapShot.appendItems(Array(1...100), toSection: .main)
        
        dataSource.apply(initialSnapShot, animatingDifferences: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    
}

