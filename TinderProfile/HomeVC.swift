//
//  HomeVC.swift
//  TinderProfile
//
//  Created by naman vaishnav on 14/11/18.
//  Copyright © 2018 naman vaishnav. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    var str_arr = [#imageLiteral(resourceName: "Gloves6"),#imageLiteral(resourceName: "Gloves3"),#imageLiteral(resourceName: "Gloves4"),#imageLiteral(resourceName: "Gloves2"),#imageLiteral(resourceName: "Gloves1"),#imageLiteral(resourceName: "Gloves5")]
    
    @IBOutlet weak var dragReorderCollectionView: UICollectionView!
    let dragReorderLayout = NVDraggableLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragReorderCollectionView.setCollectionViewLayout(dragReorderLayout, animated: false)
        //        dragReorderLayout.setupPlaceHoldersInView(view: holderView)
        
    }
    
}

extension HomeVC : UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return str_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imgView.image = str_arr[indexPath.row]
        cell.btnCount.setTitle("\(indexPath.row)", for: .normal)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}

extension HomeVC : VVSDraggableCellDelegate {
    func cellDidMove(fromIndex: NSIndexPath, toIndex: NSIndexPath) {
        print("\(fromIndex) \n \(toIndex)" )
        let fromCell = self.dragReorderCollectionView.cellForItem(at: fromIndex as IndexPath) as! CollectionViewCell
        fromCell.btnCount.setTitle("\(fromIndex.row)", for: .normal)
        
        let toCell = self.dragReorderCollectionView.cellForItem(at: toIndex as IndexPath) as! CollectionViewCell
        toCell.btnCount.setTitle("\(toIndex.row)", for: .normal)
        
        str_arr.swapAt(fromIndex.row,toIndex.row)
    }
}
