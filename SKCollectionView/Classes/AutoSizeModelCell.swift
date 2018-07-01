//
//  AutoSizeModelCell.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 29/6/18.
//

import UIKit

public protocol AutoSizeModelCell: SimpleModelCell {
    static var sizingCell:Self { get set }
}

public extension AutoSizeModelCell {
    
    public static func calculateSize(model:ModelType?, collectionView:UICollectionView) -> CGSize {
        var view = (sizingCell as! UIView)
        if let cell = sizingCell as? UICollectionViewCell {
            view = cell.contentView
        }
        view.frame.size.width = collectionView.frame.size.width
        sizingCell.model = model
        var fittingSize = UILayoutFittingCompressedSize
        fittingSize.width = collectionView.frame.size.width
        var size = view.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        size.width = fittingSize.width
        return size
        //return CGSize(width: 320, height: 200)
    }
    
    public static func curriedCalculateSize(getModel:@escaping (IndexPath) -> ModelType?) -> (UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize {
        return { collectionView,layout,indexPath in
            return calculateSize(model: getModel(indexPath), collectionView: collectionView)
        }
    }
    
    public static func curriedCalculateSize(withModel:ModelType?) -> (UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize {
        return { collectionView,layout,indexPath in
            return calculateSize(model: withModel, collectionView: collectionView)
        }
    }
    
    static func defaultSection(getModel:@escaping (IndexPath) -> ModelType?,getCount:@escaping SectionCountBlock, collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        updateSection(section: section, getModel: getModel, getCount: getCount, collectionView: collectionView)
        return section
    }
    
    static func defaultSection(items:[ModelType], collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        
        return section
    }
    
    //This could possibly be rolled into the one above
    static func defaultSection(object:ModelType,collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        self.updateSection(section: section, object: object, collectionView: collectionView)
        return section
    }
    
    static func updateSection(section:SKCVSectionController,getModel:@escaping (IndexPath) -> ModelType?,getCount:@escaping SectionCountBlock, collectionView:UICollectionView) {
        collectionView.register(clazz: self as! AnyClass)
        section.numberOfItemsInSection = getCount
        section.cellForItemAt = { (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = curriedDefaultCell(getModel: getModel)(collectionView,indexPath)
            return cell as! UICollectionViewCell
        }
        
        section.sizeForItemAt = curriedCalculateSize(getModel: getModel)
    }
    
    static func updateSection(section:SKCVSectionController,object:ModelType,collectionView:UICollectionView) {
        collectionView.register(clazz: self as! AnyClass)
        section.fixedCellCount = 1
        section.cellForItemAt = { (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = curriedDefaultCell(withModel: object)(collectionView,indexPath)
            return cell as! UICollectionViewCell
        }
        
        section.sizeForItemAt = curriedCalculateSize(withModel: object)
    }
    
    static func updateSection(section:SKCVSectionController,items:[ModelType], collectionView:UICollectionView) {
        //let getModel = items
    }
    
}
