//
//  LottieButton.swift
//  TinderProfile
//
//  Created by naman vaishnav on 26/11/18.
//  Copyright © 2018 naman vaishnav. All rights reserved.
//

import Foundation
//import SnapKit
import Lottie

open class LottieButton: UIButton {
    
    public private(set) var animationView: LOTAnimationView?
    
    public var animationName: String! {
        didSet {
            self.animationView?.removeFromSuperview()
            self.animationView = LOTAnimationView(name: animationName, bundle: Bundle(for: type(of: self)))
            
            if let animationView = self.animationView {
                self.add(animationView)
            }
        }
    }
    
    private func add(_ animationView: LOTAnimationView) {
        self.addSubview(animationView)
//        animationView.snp.makeConstraints { make in
//            make.edges.equalTo(self.imageView!)
//        }
        animationView.frame = (self.imageView?.frame)!
        animationView.isHidden = true
    }
    
    private func blankImage(for image: UIImage?) -> UIImage? {
        UIGraphicsBeginImageContext(image?.size ?? .zero)
        let blankImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return blankImage
    }
    
    public func playAnimation(withInitialStateImage initialStateImage: UIImage,
                              andFinalStateImage finalStateImage: UIImage) {
        let blankImage = self.blankImage(for: initialStateImage)
        self.setImage(blankImage, for: .normal)
        self.animationView?.isHidden = false
        
        self.animationView?.play(completion: { completed in
            self.setImage(finalStateImage, for: .normal)
            self.animationView?.isHidden = true
            self.animationView?.pause()
            self.animationView?.animationProgress = 0
        })
    }
    
    open func playAnimation() {
        guard let image = self.image(for: .normal) else { return }
        self.playAnimation(withInitialStateImage: image, andFinalStateImage: image)
    }
}

