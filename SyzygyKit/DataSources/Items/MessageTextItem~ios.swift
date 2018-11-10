//
//  MessageTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public class MessageTextItem: DataSourceItemCell {
    
    private let messageLabel: UILabel
    
    public convenience init(action: Action) {
        self.init(message: action.name, action: action)
    }
    
    public init(message: String, action: Action? = nil) {
        self.messageLabel = UILabel(frame: .zero)
        
        super.init()
        selectionAction = action
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.textColor = action == nil ? .darkText : Color.action.color
        
        contentView.addSubview(messageLabel)
        
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11.0),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
}
