//
//  SimpleModelCell.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 29/6/18.
//

import UIKit

public protocol SimpleModelCell {
    associatedtype ModelType
    var model:ModelType? {get set}
}

public extension SimpleModelCell {
    public static func defaultCell(collectionView:UICollectionView,indexPath:IndexPath,model:ModelType?) -> Self {
        let ident = String(describing: Self.self)
        var cell:Self = collectionView.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! Self
        cell.model = model
        return cell
    }
    
    public static func curriedDefaultCell(withModel: ModelType?) -> (UICollectionView,IndexPath) -> Self {
        return { collectionView,indexPath in
            return defaultCell(collectionView: collectionView, indexPath: indexPath, model: withModel)
        }
    }
    
    public static func curriedDefaultCell(getModel:@escaping (IndexPath) -> ModelType?) -> (UICollectionView,IndexPath) -> Self {
        return { collectionView,indexPath in
            return defaultCell(collectionView: collectionView, indexPath: indexPath, model: getModel(indexPath))
        }
    }
    
    public static func curriedSupplementaryView(withModel model:ModelType) -> (UICollectionView,String,IndexPath) -> Self {
        return { collectionView,kind,indexPath in
            let ident = String(describing: Self.self)
            var view:Self = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ident, for: indexPath) as! Self
            view.model = model
            return view
        }
    }
    
    
}
