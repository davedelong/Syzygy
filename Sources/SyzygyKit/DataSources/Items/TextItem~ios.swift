//
//  TextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/21/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import Foundation

open class TextItem: DataSourceItemCell {
    
    private let label: UILabel
    
    public init(text: String, style: UIFont.TextStyle, alignment: NSTextAlignment = .natural, padding: UIEdgeInsets? = nil) {
        label = UILabel(frame: .zero)
        super.init()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.textAlignment = alignment
        
        contentView.addSubview(label)
        
        if let padding = padding {
            NSLayoutConstraint.activate([
                label.leading.constraint(equalTo: contentView.leading, constant: padding.left),
                label.top.constraint(equalTo: contentView.top, constant: padding.top),
                
                contentView.trailing.constraint(equalTo: label.trailing, constant: padding.right),
                contentView.bottom.constraint(equalTo: label.bottom, constant: padding.bottom)
            ])
        } else {
            NSLayoutConstraint.activate([
                label.leading.constraint(equalToSystemSpacingAfter: contentView.leading),
                label.top.constraint(equalToSystemSpacingBelow: contentView.top),
                
                contentView.trailing.constraint(equalToSystemSpacingAfter: label.trailing),
                contentView.bottom.constraint(equalToSystemSpacingBelow: label.bottom)
            ])
        }
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

#endif
