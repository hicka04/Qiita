//
//  UIImageView+extension.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/23.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    
    func loadImage(from url: URL) {
        Nuke.loadImage(with: url, into: self)
    }
}
