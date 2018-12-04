//
//  CardVC.swift
//  TinderProfile
//
//  Created by naman vaishnav on 23/11/18.
//  Copyright © 2018 naman vaishnav. All rights reserved.
//

import UIKit
import MGSwipeCards



class CardVC: UIViewController {
    @IBOutlet weak var btn: LottieButton!
    let cardStack = MGCardStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        cardStack.delegate = self
//        cardStack.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btn.animationName = "TwitterHeart"
    }
    @IBAction func action(_ sender: Any) {
        btn.playAnimation()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - MGCardStackViewDataSource

//extension CardVC: MGCardStackViewDataSource {
//    func cardStack(_ cardStack: MGCardStackView, cardForIndexAt index: Int) -> MGSwipeCard {
//        return SampleCard() as MGSwipeCard
//    }
//
//    func numberOfCards(in cardStack: MGCardStackView) -> Int {
//        return 5
//    }
//}

////MARK: - MGCardStackViewDelegate
//
//extension CardVC: MGCardStackViewDelegate {
//    func didSwipeAllCards(_ cardStack: MGCardStackView) {
//        print("Swiped all cards!")
//    }
//
//    func cardStack(_ cardStack: MGCardStackView, didUndoCardAt index: Int, from direction: SwipeDirection) {
////        print("Undo \(direction) swipe on \")
//    }
//
//    func cardStack(_ cardStack: MGCardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection) {
////        print("Swiped \(direction) on \(cardModels[index].name)")
//    }
//
//    func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int, tapCorner: UIRectCorner) {
//        var cornerString: String
//        switch tapCorner {
//        case .topLeft:
//            cornerString = "top left"
//        case .topRight:
//            cornerString = "top right"
//        case .bottomRight:
//            cornerString = "bottom right"
//        case .bottomLeft:
//            cornerString = "bottom left"
//        default:
//            cornerString = ""
//        }
//        print("Card tapped at \(cornerString)")
//    }
//}
