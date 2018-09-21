//
//  DetailEntriesItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class DetailEntriesItem: UITableViewCellDefault, DataSourceItem {
    public typealias Entry = (NSAttributedString, NSAttributedString)
    
    private let titleLabel: UILabel
    private let detailStack: UIStackView
    
    public init(title: String, entries: Array<Entry>) {
        self.titleLabel = UILabel(frame: .zero)
        self.detailStack = UIStackView(arrangedSubviews: [])
        
        super.init(style: .default, reuseIdentifier: "DetailEntriesItem")
        
        selectable = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.text = title
        
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        detailStack.axis = .vertical
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailStack)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor),
            
            detailStack.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            detailStack.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: detailStack.bottomAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: detailStack.trailingAnchor, multiplier: 1.0)
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
            primary.leadingAnchor.constraint(equalTo: leadingAnchor),
            primary.topAnchor.constraint(equalTo: topAnchor),
            primary.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            trailingAnchor.constraint(equalTo: secondary.trailingAnchor),
            secondary.topAnchor.constraint(equalTo: topAnchor),
            secondary.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            secondary.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: primary.trailingAnchor, multiplier: 1.0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}
