//
//  SampleCardFooterView.swift
//  MGSwipeCards_Example
//
//  Created by Mac Gallagher on 11/14/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class SampleCardFooterView: UIView {
    private var title: String?
    private var subtitle: String?
    private var label = UILabel()
    private var gradientLayer: CAGradientLayer?
    
    init(title: String?, subtitle: String?) {
        super.init(frame: CGRect.zero)
        self.title = title
        self.subtitle = subtitle
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        backgroundColor = .clear
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10 //only modify bottom corners
        clipsToBounds = true
        initializeLabel()
    }
    
    private func initializeLabel() {
        let attributedText = NSMutableAttributedString(string: (title ?? "") + "\n", attributes: NSAttributedString.Key.titleAttributes)
        
        if subtitle != nil && subtitle != "" {
            attributedText.append(NSMutableAttributedString(string: subtitle!, attributes: NSAttributedString.Key.subtitleAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
            label.numberOfLines = 2
        }
        
        label.attributedText = attributedText
        addSubview(label)
    }
    
    override func layoutSubviews() {
        let padding: CGFloat = 20
        label.frame = CGRect(x: padding, y: bounds.height - label.intrinsicContentSize.height - padding, width: bounds.width - 2 * padding, height: label.intrinsicContentSize.height)
    }
}

extension NSAttributedString.Key {
    static var shadowAttribute: NSShadow = {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 2
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.3)
        return shadow
    }()
    
    static var titleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "ArialRoundedMTBold", size: 24)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
    
    static var subtitleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont(name: "Arial", size: 17)!,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.shadow: NSAttributedString.Key.shadowAttribute
    ]
}
