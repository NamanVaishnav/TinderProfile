//
//  ViewController.swift
//  TinderProfile
//
//  Created by naman vaishnav on 14/11/18.
//  Copyright © 2018 naman vaishnav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var str_arr = [#imageLiteral(resourceName: "Gloves6"),#imageLiteral(resourceName: "Gloves3"),#imageLiteral(resourceName: "Gloves4"),#imageLiteral(resourceName: "Gloves2"),#imageLiteral(resourceName: "Gloves1"),#imageLiteral(resourceName: "Gloves5")]
    
    @IBOutlet weak var dragReorderCollectionView: UICollectionView!
    let dragReorderLayout = NVDraggableLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragReorderCollectionView.setCollectionViewLayout(dragReorderLayout, animated: false)
        //        dragReorderLayout.setupPlaceHoldersInView(view: holderView)
        
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return str_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imgView.image = str_arr[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = str_arr.remove(at: sourceIndexPath.item)
        str_arr.insert(item, at: destinationIndexPath.item)
        print(str_arr)
    }
    
}
