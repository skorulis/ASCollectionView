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
}
