//
//  InfoActionButton.swift
//  Heathen
//
//  Created by Dave DeLong on 10/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import UIKit

class InfoActionButton: UIView {
    
    @IBOutlet private(set) var titleLabel: UILabel?
    @IBOutlet private(set) var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 31, height: 14))
        
        titleLabel = l
        imageView = iv
        
        addConstraints([
            iv.widthAnchor.constraint(equalTo: iv.heightAnchor, multiplier: 1.0),
            iv.heightAnchor.constraint(equalToConstant: 32),
            
            iv.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            l.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 2),
            bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: 2),
            
            iv.centerXAnchor.constraint(equalTo: centerXAnchor),
            l.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(iv)
        addSubview(l)
    }
    
}

#endif
