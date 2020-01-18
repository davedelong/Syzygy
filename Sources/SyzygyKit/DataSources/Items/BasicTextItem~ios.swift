//
//  BasicTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class BasicTextItem: DataSourceItemCell {
    
    public var title: String {
        didSet { titleLabel.text = title }
    }
    
    public var detail: String {
        didSet { detailLabel.text = detail }
    }
    
    private let titleLabel: UILabel
    private let detailLabel: UILabel
    
    public init(title: String, detail: String, actions: Array<Action> = []) {
        self.title = title
        self.detail = detail
        
        self.titleLabel = UILabel(frame: .zero)
        self.detailLabel = UILabel(frame: .zero)
        
        super.init()
        
        self.actions = actions
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
            titleLabel.leading.constraint(equalToSystemSpacingAfter: contentView.leading),
            titleLabel.top.constraint(equalToSystemSpacingBelow: contentView.top),
            contentView.trailing.constraint(greaterThanOrEqualTo: titleLabel.trailing),
            
            detailLabel.leading.constraint(equalToSystemSpacingAfter: contentView.leading),
            detailLabel.top.constraint(equalToSystemSpacingBelow: titleLabel.bottom),
            contentView.bottom.constraint(equalToSystemSpacingBelow: detailLabel.bottom),
            contentView.trailing.constraint(greaterThanOrEqualTo: detailLabel.trailing)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}
