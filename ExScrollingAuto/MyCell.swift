//
//  MyCell.swift
//  ExScrollingAuto
//
//  Created by Jake.K on 2022/05/02.
//

import UIKit

final class MyCell: UICollectionViewCell {
  static let id = "MyCell"
  required init?(coder: NSCoder) {
    fatalError()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .random
  }
}
