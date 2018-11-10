//
//  TitleTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class TitleTextItem: DataSourceItemCell {
    
    private let titleLabel: UILabel
    
    public init(title: String) {
        self.titleLabel = UILabel(frame: .zero)
        
        super.init()
        
        selectable = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.text = title
        
        contentView.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}
