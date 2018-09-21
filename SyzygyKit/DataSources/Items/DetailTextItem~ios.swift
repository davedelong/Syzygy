//
//  DetailTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 9/16/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

open class DetailTextItem: UITableViewCellDefault, DataSourceItem {
    
    public convenience init(headline: String, detail: String = "") {
        let t = NSAttributedString(string: headline, attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)])
        let d = NSAttributedString(string: detail, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        self.init(title: t, detail: d)
    }
    
    public convenience init(title: String, detail: String) {
        let t = NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        let d = NSAttributedString(string: detail, attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])
        self.init(title: t, detail: d)
    }
    
    public init(title: NSAttributedString, detail: NSAttributedString) {
        super.init(style: .default, reuseIdentifier: "DetailTextItem")
        
        selectable = false
        
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.adjustsFontForContentSizeCategory = true
        t.numberOfLines = 0
        t.attributedText = title
        contentView.addSubview(t)
        
        let d = UILabel()
        d.translatesAutoresizingMaskIntoConstraints = false
        d.adjustsFontForContentSizeCategory = true
        d.numberOfLines = 0
        d.textAlignment = .right
        d.attributedText = detail
        contentView.addSubview(d)
        
        NSLayoutConstraint.activate([
            t.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            t.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: t.bottomAnchor, multiplier: 1.0),
            
            d.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: t.leadingAnchor, multiplier: 1.0),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: d.trailingAnchor, multiplier: 1.0),
            d.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: d.bottomAnchor, multiplier: 1.0),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}
