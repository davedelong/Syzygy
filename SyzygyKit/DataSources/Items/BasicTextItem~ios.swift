//
//  BasicTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class BasicTextItem: UITableViewCellDefault, DataSourceItem {
    
    public var title: String {
        didSet { titleLabel.text = title }
    }
    
    public var detail: String {
        didSet { detailLabel.text = detail }
    }
    
    private let titleLabel: UILabel
    private let detailLabel: UILabel
    
    public var selectionAction: Action? {
        didSet { selectable = (selectionAction != nil) }
    }
    
    public var actions = Array<Action>()
    
    public init(title: String, detail: String, actions: Array<Action> = []) {
        self.title = title
        self.detail = detail
        self.actions = actions
        
        self.titleLabel = UILabel(frame: .zero)
        self.detailLabel = UILabel(frame: .zero)
        
        super.init(style: .default, reuseIdentifier: "BasicTextItem")
        
        selectable = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.text = title
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.numberOfLines = 0
        detailLabel.text = detail
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor),
            
            detailLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            detailLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: detailLabel.bottomAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: detailLabel.trailingAnchor)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
    public func handleSelection() {
        selectionAction?.handler(self)
    }
    
    public func contextualActions() -> Array<Action> {
        return actions
    }
    
}
