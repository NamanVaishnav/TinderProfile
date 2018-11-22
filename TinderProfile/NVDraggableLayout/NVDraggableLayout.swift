//
//  NVDraggableLayout.swift
//  TinderProfile
//
//  Created by naman vaishnav on 14/11/18.
//  Copyright © 2018 naman vaishnav. All rights reserved.
//

import Foundation
import UIKit


@objc protocol VVSDraggableCellDelegate : UICollectionViewDelegate {
    
    func cellDidMove(fromIndex : NSIndexPath, toIndex: NSIndexPath) -> Void
    
}

class NVDraggableLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate {
    
    var cellAttributes : [UICollectionViewLayoutAttributes] = []
    var animating : Bool = false
    var collectionViewFrameInCanvas : CGRect = .zero
    var hitTestRectagles = [String:CGRect]()
    var darkTintView = UIView()
    var draggableArea : UIView? {
        didSet {
            if draggableArea != nil {
                calculateBorders()
            }
        }
    }
    
    struct DraggedCell {
        var offset : CGPoint = .zero
        var sourceCell : UICollectionViewCell
        var representationImageView : UIView
        var currentIndexPath : NSIndexPath
    }
    var draggedCell : DraggedCell?
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (collectionView?.frame.width)!, height: (collectionView?.frame.width)!)
    }
    
    var spacing: CGFloat = 15
    var smallerCellWidth: CGFloat {
        return 0.28*(collectionView?.bounds.width)!
    }
    var biggerCellWidth: CGFloat {
        return 0.6*(collectionView?.bounds.width)!
    }
    
    override func prepare() {
        super.prepare()
        self.setup()
        self.calculateBorders()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        let numberOfsections = (collectionView?.numberOfSections)!
        for section in 0..<numberOfsections
        {
            let numberOfCells = (collectionView?.numberOfItems(inSection: section))!
            cellAttributes = []
            for item in 0..<numberOfCells
            {
                cellAttributes.append(getAttributes(indexPath: NSIndexPath(item: item, section: section)))
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var attrs = [UICollectionViewLayoutAttributes]()
        for cellAttribute in cellAttributes {
            if rect.contains((cellAttribute.frame)) {
                attrs.append(cellAttribute)
            }
        }
        return attrs
    }
    
    func setupPlaceHoldersInView(view: UIView)
    {
        view.backgroundColor = UIColor.clear
        for i in 0...5
        {
            let placeHolder = UIView(frame: getAttributes(indexPath: NSIndexPath(item: i, section: 0)).frame)
            placeHolder.backgroundColor = UIColor.green
            view.addSubview(placeHolder)
            view.sendSubviewToBack(placeHolder)
        }
    }
    
    func getAttributes(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes
    {
        let cellAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
        switch indexPath.row%6
        {
        case 0: cellAttribute.frame = CGRect(x: spacing, y: spacing, width: biggerCellWidth , height: biggerCellWidth)
        case 1: cellAttribute.frame = CGRect(x: biggerCellWidth + 2*spacing, y: spacing, width: smallerCellWidth, height: smallerCellWidth)
        case 2: cellAttribute.frame = CGRect(x: biggerCellWidth + 2*spacing, y: smallerCellWidth + 2*spacing, width: smallerCellWidth, height: smallerCellWidth)
        case 3: cellAttribute.frame = CGRect(x: biggerCellWidth + 2*spacing, y: 2*smallerCellWidth + 3*spacing, width: smallerCellWidth, height: smallerCellWidth)
        case 4: cellAttribute.frame = CGRect(x: smallerCellWidth + 2*spacing, y: 2*smallerCellWidth + 3*spacing, width: smallerCellWidth, height: smallerCellWidth)
        case 5: cellAttribute.frame = CGRect(x: spacing, y: 2*smallerCellWidth + 3*spacing, width: smallerCellWidth, height: smallerCellWidth)
        default: fatalError("This should never happen! Fret!")
        }
        return cellAttribute
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath as IndexPath)
        let attribute = getAttributes(indexPath: indexPath as NSIndexPath)
        return attribute
    }
    
    func setup() {
        darkTintView.backgroundColor = UIColor.black
        if let collectionView = collectionView {
            
            let longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
            
            longPressGestureRecogniser.minimumPressDuration = 0.3
            longPressGestureRecogniser.delegate = self
            
            collectionView.addGestureRecognizer(longPressGestureRecogniser)
            
            if draggableArea == nil {
                draggableArea = collectionView.superview
            }
        }
    }
    
    private func calculateBorders() {
        
        if let collectionView = collectionView {
            
            collectionViewFrameInCanvas = collectionView.frame
            
            if draggableArea != collectionView.superview {
                collectionViewFrameInCanvas = draggableArea!.convert(collectionViewFrameInCanvas, from: collectionView)
            }
            
            var leftRect : CGRect = collectionViewFrameInCanvas
            leftRect.size.width = 20.0
            hitTestRectagles["left"] = leftRect
            
            var topRect : CGRect = collectionViewFrameInCanvas
            topRect.size.height = 20.0
            hitTestRectagles["top"] = topRect
            
            var rightRect : CGRect = collectionViewFrameInCanvas
            rightRect.origin.x = rightRect.size.width - 20.0
            rightRect.size.width = 20.0
            hitTestRectagles["right"] = rightRect
            
            var bottomRect : CGRect = collectionViewFrameInCanvas
            bottomRect.origin.y = bottomRect.origin.y + rightRect.size.height - 20.0
            bottomRect.size.height = 20.0
            hitTestRectagles["bottom"] = bottomRect
        }
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleGesture(gesture: UILongPressGestureRecognizer) -> Void {
        
        let dragPointOnCanvas = gesture.location(in: draggableArea)
        if gesture.state == UIGestureRecognizer.State.began {
            
            if let ca = draggableArea {
                
                if let cv = collectionView {
                    
                    let pointPressedInCanvas = gesture.location(in: ca)
                    
                    for cell in cv.visibleCells {
                        
                        let cellInCanvasFrame = ca.convert(cell.frame, from: cv)
                        
                        if cellInCanvasFrame.contains(pointPressedInCanvas ) {
                            let representationImage = cell.snapshotView(afterScreenUpdates: true)
                            representationImage?.frame = cellInCanvasFrame
                            
                            let offset = CGPoint(pointPressedInCanvas.x - cellInCanvasFrame.origin.x, pointPressedInCanvas.y - cellInCanvasFrame.origin.y)
                            let indexPath : NSIndexPath = cv.indexPath(for: cell as UICollectionViewCell)! as NSIndexPath
                            draggedCell = DraggedCell(
                                offset: offset,
                                sourceCell: cell,
                                representationImageView:representationImage!,
                                currentIndexPath: indexPath
                            )
                            break
                        }
                    }
                }
            }
            if draggedCell != nil
            {
                draggedCell!.sourceCell.isHidden = true
                draggableArea?.addSubview(draggedCell!.representationImageView)
                darkTintView.frame = draggedCell!.representationImageView.bounds
                UIView.animate(withDuration: 0.15, animations: { [weak self]() -> Void in
                    self?.draggedCell!.representationImageView.alpha = 0.8
                })
            }
            
        }
        
        if draggedCell != nil
        {
            if gesture.state == UIGestureRecognizer.State.changed {
                
                // Update the representation image
                var imageViewFrame = draggedCell!.representationImageView.frame
                var point =  CGPoint(x: 0,y :0)
                point.x = dragPointOnCanvas.x - draggedCell!.offset.x
                point.y = dragPointOnCanvas.y - draggedCell!.offset.y
                imageViewFrame.origin = point
                draggedCell!.representationImageView.frame = imageViewFrame
                let dragPointOnCollectionView = gesture.location(in: self.collectionView)
                if let indexPath : NSIndexPath = self.collectionView?.indexPathForItem(at: dragPointOnCollectionView) as NSIndexPath? {
                    if indexPath.isEqual(draggedCell!.currentIndexPath) == false {
                        if let delegate = self.collectionView!.delegate as? VVSDraggableCellDelegate {
                            delegate.cellDidMove(fromIndex: draggedCell!.currentIndexPath, toIndex: indexPath)
                        }
                        self.collectionView!.moveItem(at: draggedCell!.currentIndexPath as IndexPath, to: indexPath as IndexPath)
                        self.draggedCell!.currentIndexPath = indexPath
                        let cell = self.collectionView?.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
//                        let cell2 = self.collectionView?.cellForItem(at: draggedCell.so)
                        cell.btnCount.setTitle("\(indexPath.row)", for: .normal)
                        
                        
                        
                    }
                    
                }
                 
            }
            
            if gesture.state == UIGestureRecognizer.State.ended || gesture.state == UIGestureRecognizer.State.failed || gesture.state == UIGestureRecognizer.State.cancelled  {
                draggedCell!.sourceCell.isHidden = false
                draggedCell!.representationImageView.removeFromSuperview()
                if let _ = self.collectionView?.delegate as? VVSDraggableCellDelegate {
                    self.collectionView!.reloadData()
                }
                self.draggedCell = nil
            }
            
        }
    }
    
    
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
