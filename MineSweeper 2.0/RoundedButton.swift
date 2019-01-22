//
//  RoundedButton.swift
//  MineSweeper 2.0
//
//  Created by Yuchen Zhu on 2018-06-06.
//  Copyright © 2018 Momendie. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 2/UIScreen.main.nativeScale
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 5
    }
}
