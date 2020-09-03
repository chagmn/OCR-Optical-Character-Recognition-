//
//  ScanImageView.swift
//  OCR Test
//
//  Created by 창민 on 2020/09/03.
//  Copyright © 2020 창민. All rights reserved.
//

import UIKit

class ScanImageView: UIImageView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init가 구현되지 않았습니다.")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        clipsToBounds = true
    }
}
