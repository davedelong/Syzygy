//
//  MessageTextItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import Foundation

public class MessageTextItem: DataSourceItemCell {
    
    private let messageLabel: UILabel
    private let background: UIImageView
    
    public convenience init(background: UIImage? = nil, action: Action, actionColor: PlatformColor = .action) {
        self.init(message: action.name, background: background, action: action, actionColor: actionColor)
    }
    
    public init(message: String, background: UIImage? = nil, action: Action? = nil, actionColor: PlatformColor = .action) {
        self.messageLabel = UILabel(frame: .zero)
        self.background = UIImageView(image: background)
        
        super.init()
        selectionAction = action
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.textColor = action == nil ? .darkText : actionColor
        
        if let bg = background, bg.size.height > 0 {
            let ratio = bg.size.width / bg.size.height
            
            self.background.contentMode = .scaleAspectFit
            self.background.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(self.background)
            NSLayoutConstraint.activate([
                self.background.top.constraint(equalTo: contentView.top),
                self.background.leading.constraint(equalTo: contentView.leading),
                self.background.width.constraint(equalTo: self.background.height, multiplier: ratio),
                
                contentView.bottom.constraint(equalTo: self.background.bottom),
                contentView.trailing.constraint(equalTo: self.background.trailing)
            ])
        }
        
        contentView.addSubview(self.messageLabel)
        
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            messageLabel.leading.constraint(greaterThanOrEqualToSystemSpacingAfter: contentView.leading),
            messageLabel.top.constraint(equalTo: contentView.top, constant: 11.0),
            messageLabel.height.constraint(greaterThanOrEqualToConstant: 22.0)
        ])
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
}

#endif
