//
//  SKCVSectionController.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 29/6/18.
//

import UIKit

public typealias SectionCountBlock = (UICollectionView,Int) -> Int

public class SKCVSectionController: NSObject {

    public var fixedSize:CGSize?
    public var fixedHeight:CGFloat?
    public var fixedCellCount:Int = 1
    
    public var fixedHeaderHeight:CGFloat?
    public var fixedFooterHeight:CGFloat?
    
    public var cellForItemAt: ((UICollectionView,IndexPath) -> UICollectionViewCell)!
    public var willDisplayCell: ((UICollectionView,UICollectionViewCell,IndexPath) -> ())?
    public var didSelectItemAt: ((UICollectionView,IndexPath) -> () )?
    public var viewForSupplementaryElementOfKind: ((UICollectionView,String,IndexPath) -> UICollectionReusableView)?
    public var willDisplaySupplementaryView: ((UICollectionView,UICollectionReusableView,String,IndexPath) -> ())?
    public var numberOfItemsInSection: SectionCountBlock?
    public var simpleNumberOfItemsInSection: (() ->Int)?
    
    public var sizeForItemAt: ((UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize)?
    public var referenceSizeForHeader: ((UICollectionView,UICollectionViewLayout, Int) -> CGSize)?
    
    public convenience init(fixedHeight:CGFloat,cellForItemAt:((UICollectionView,IndexPath) -> UICollectionViewCell)!) {
        self.init()
        self.fixedHeight = fixedHeight
        self.cellForItemAt = cellForItemAt
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let block = numberOfItemsInSection {
            return block(collectionView,section)
        }
        if let block = simpleNumberOfItemsInSection {
            return block()
        }
        return fixedCellCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(cellForItemAt != nil) //Must be set by this point
        return cellForItemAt(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid = collectionView.frame.size.width
        
        if let s = sizeForItemAt {
            return s(collectionView,collectionViewLayout,indexPath)
        }
        if let f = fixedHeight {
            return CGSize(width: wid, height: f)
        }
        if let f = fixedSize {
            return f
        }
        
        return CGSize(width: wid, height: 44)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let block = referenceSizeForHeader {
            return block(collectionView, collectionViewLayout, section)
        }
        
        if let f = fixedHeaderHeight {
            return CGSize(width: collectionView.frame.size.width, height: f)
        }
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let f = fixedFooterHeight {
            return CGSize(width: collectionView.frame.size.width, height: f)
        }
        return CGSize.zero
    }
    
}
