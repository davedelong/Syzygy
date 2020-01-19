//
//  DetailEntriesItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import UIKit

open class DetailEntriesItem: DataSourceItemCell {
    public typealias Entry = (NSAttributedString, NSAttributedString)
    
    private let titleLabel: UILabel
    private let captionLabel: UILabel
    private let detailStack: UIStackView
    
    public init(title: String, caption: NSAttributedString? = nil, entries: Array<Entry>) {
        self.titleLabel = UILabel(frame: .zero)
        self.captionLabel = UILabel(frame: .zero)
        self.detailStack = UIStackView(arrangedSubviews: [])
        
        super.init()
        
        selectable = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.text = title
        
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        captionLabel.adjustsFontForContentSizeCategory = true
        captionLabel.attributedText = caption
        captionLabel.textAlignment = .right
        
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        detailStack.axis = .vertical
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(detailStack)
        
        NSLayoutConstraint.activate([
            titleLabel.leading.constraint(equalToSystemSpacingAfter: contentView.leading),
            titleLabel.top.constraint(equalToSystemSpacingBelow: contentView.top),
            
            captionLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
            captionLabel.leading.constraint(greaterThanOrEqualToSystemSpacingAfter: titleLabel.trailing),
            contentView.trailing.constraint(equalToSystemSpacingAfter: captionLabel.trailing),
            
            detailStack.leading.constraint(equalToSystemSpacingAfter: contentView.leading),
            detailStack.top.constraint(equalToSystemSpacingBelow: titleLabel.bottom),
            contentView.bottom.constraint(equalToSystemSpacingBelow: detailStack.bottom),
            contentView.trailing.constraint(equalToSystemSpacingAfter: detailStack.trailing)
        ])
        
        for entry in entries {
            let view = DetailEntryView(label: entry.0, detail: entry.1)
            detailStack.addArrangedSubview(view)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

private class DetailEntryView: UIView {
    
    init(label: NSAttributedString, detail: NSAttributedString) {
        super.init(frame: .zero)
        
        let primary = UILabel(frame: .zero)
        primary.translatesAutoresizingMaskIntoConstraints = false
        primary.adjustsFontForContentSizeCategory = true
        primary.attributedText = label
        
        let secondary = UILabel(frame: .zero)
        secondary.translatesAutoresizingMaskIntoConstraints = false
        secondary.adjustsFontForContentSizeCategory = true
        secondary.textAlignment = .right
        secondary.attributedText = detail
        
        addSubview(primary)
        addSubview(secondary)
        
        NSLayoutConstraint.activate([
            primary.leading.constraint(equalTo: leadingAnchor),
            primary.top.constraint(equalTo: topAnchor),
            primary.bottom.constraint(equalTo: bottomAnchor),
            
            trailingAnchor.constraint(equalTo: secondary.trailing),
            secondary.top.constraint(equalTo: topAnchor),
            secondary.bottom.constraint(equalTo: bottomAnchor),
            
            secondary.leading.constraint(greaterThanOrEqualToSystemSpacingAfter: primary.trailing)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

#endif
