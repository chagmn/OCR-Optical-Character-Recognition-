//
//  OcrTextView.swift
//  OCR Test
//
//  Created by 창민 on 2020/09/03.
//  Copyright © 2020 창민. All rights reserved.
//

import UIKit

class OcrTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: textContainer)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init을 구성하세요!!")
    }
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 7.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
        font = .systemFont(ofSize: 16.0)
    }
}
