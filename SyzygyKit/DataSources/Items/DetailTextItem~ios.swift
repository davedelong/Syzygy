//
//  DetailTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class DetailTextItem: DataSourceItemCell {
    
    public convenience init(headline: String, detail: String = "") {
        let t = NSAttributedString(string: headline, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        self.init(title: t, detail: detail)
    }
    
    public convenience init(title: String, detail: String) {
        let t = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        self.init(title: t, detail: detail)
    }
    
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    public init(title: NSAttributedString, detail: String) {
        super.init()
        
        selectable = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = title
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(titleLabel)

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .right
        detailLabel.text = detail
        detailLabel.font = UIFont.preferredFont(forTextStyle: .body)
        contentView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            // horizontal
            titleLabel.leading.constraint(equalToSystemSpacingAfter: contentView.leading),
            detailLabel.leading.constraint(greaterThanOrEqualToSystemSpacingAfter: titleLabel.trailing),
            contentView.trailing.constraint(equalToSystemSpacingAfter: detailLabel.trailing),
            
            // title vertical
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.top.constraint(greaterThanOrEqualToSystemSpacingBelow: contentView.top),
            
            // detail vertical
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailLabel.top.constraint(equalToSystemSpacingBelow: contentView.top),
            
            // cell min height
            contentView.height.constraint(greaterThanOrEqualToConstant: 44.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}
