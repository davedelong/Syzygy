//
//  UITableViewCell.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 1/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public extension UITableViewCell {
    
    static func nib() -> UINib? {
        return UINib(nibName: "\(self)", bundle: Bundle(for: self))
    }
    
}

open class UITableViewCellDefault: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

open class UITableViewCellValue1: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

open class UITableViewCellValue2: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}

open class UITableViewCellSubtitle: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
}



open class ViewControllerTableViewCell: UITableViewCell {
    
    private let content: UIViewController
    
    public init(content: UIViewController, margins: PlatformEdgeInsets = .zero) {
        self.content = content
        super.init(style: .default, reuseIdentifier: "\(type(of: content))")
        contentView.embedSubview(content.view, margins: margins)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func responds(to aSelector: Selector!) -> Bool {
        var ok = super.responds(to: aSelector)
        
        if ok == false {
            ok = content.responds(to: aSelector)
        }
        
        return ok
    }
    
    override open func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        if content.responds(to: aSelector) {
            return content.perform(aSelector, with: object)
        }
        return super.perform(aSelector, with: object)
    }
    
}
