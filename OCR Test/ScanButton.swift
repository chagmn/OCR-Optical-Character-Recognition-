//
//  ScanButton.swift
//  OCR Test
//
//  Created by 창민 on 2020/09/03.
//  Copyright © 2020 창민. All rights reserved.
//

import UIKit

class ScanButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init이 구현되지 않았습니다.")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("Scan", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel?.textColor = .white
        layer.cornerRadius = 7.0
        backgroundColor = UIColor.systemGray
    }
}


