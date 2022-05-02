//
//  ViewController.swift
//  ExScrollingAuto
//
//  Created by Jake.K on 2022/05/02.
//

import UIKit

class ViewController: UIViewController {
  private var collectionView: UICollectionView!
  
  private var dataSource = (0...30).map(Int.init(_:))
  private var scrollTimer: Timer?
  private var currentItem = -1
  private var currentIndexPath: IndexPath {
    IndexPath(item: self.currentItem, section: 0)
  }
  
  deinit {
    print("deinit: ViewController")
    self.scrollTimer?.invalidate()
    self.scrollTimer = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] section, env -> NSCollectionLayoutSection? in
        guard let ss = self else { return nil }
        return ss.getLayoutSection()
      }
    )
    self.collectionView.isScrollEnabled = true
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = true
    self.collectionView.contentInset = .zero
    self.collectionView.backgroundColor = .clear
    self.collectionView.clipsToBounds = true
    self.collectionView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
    self.collectionView.dataSource = self
    self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(self.collectionView)
    NSLayoutConstraint.activate([
      self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
      self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
      self.collectionView.heightAnchor.constraint(equalToConstant: 500),
      self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])
    
    self.scrollTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
      guard let ss = self else { return }
      let countOfIndexPath = ss.collectionView.numberOfItems(inSection: 0)
      ss.currentItem = (ss.currentItem + 1) % countOfIndexPath
      
      UIView.animate(
        withDuration: 2.0,
        animations: {
          ss.collectionView.scrollToItem(
            at: ss.currentIndexPath,
            at: .left,
            animated: true
          )
        },
        completion: nil
      )
    })
  }
  
  private func getLayoutSection() -> NSCollectionLayoutSection {
    // item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
    
    // group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    // section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset,  env) in
      guard
        let ss = self,
        let visibleIndexPath = visibleItems.last?.indexPath,
        ss.currentIndexPath != visibleIndexPath
      else { return }
      ss.currentItem = visibleIndexPath.item
    }
    return section
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.dataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath) as! MyCell
    return cell
  }
}
