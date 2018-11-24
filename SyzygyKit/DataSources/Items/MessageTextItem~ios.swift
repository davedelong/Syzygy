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
    private let background: UIImageView
    
    public convenience init(background: UIImage? = nil, action: Action) {
        self.init(message: action.name, background: background, action: action)
    }
    
    public init(message: String, background: UIImage? = nil, action: Action? = nil) {
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
        messageLabel.textColor = action == nil ? .darkText : Color.action.color
        
        if let bg = background, bg.size.height > 0 {
            let ratio = bg.size.width / bg.size.height
            
            self.background.contentMode = .scaleAspectFit
            self.background.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(self.background)
            NSLayoutConstraint.activate([
                self.background.topAnchor.constraint(equalTo: contentView.topAnchor),
                self.background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                self.background.widthAnchor.constraint(equalTo: self.background.heightAnchor, multiplier: ratio),
                
                contentView.bottomAnchor.constraint(equalTo: self.background.bottomAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.background.trailingAnchor)
            ])
        }
        
        contentView.addSubview(self.messageLabel)
        
        
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
