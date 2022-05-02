//
//  UIColor+Extension.swift
//  ExScrollingAuto
//
//  Created by Jake.K on 2022/05/02.
//

import UIKit

extension UIColor {
  static var random: UIColor {
    UIColor(
      red: CGFloat(drand48()),
      green: CGFloat(drand48()),
      blue: CGFloat(drand48()),
      alpha: 1.0
    )
  }
  func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    return UIGraphicsImageRenderer(size: size).image { rendererContext in
      self.setFill()
      rendererContext.fill(CGRect(origin: .zero, size: size))
    }
  }
}

