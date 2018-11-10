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
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            detailLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: detailLabel.trailingAnchor, multiplier: 1.0),
            
            // title vertical
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            
            // detail vertical
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            
            // cell min height
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}
