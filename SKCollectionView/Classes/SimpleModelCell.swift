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
    static func calculateSize(model:ModelType?, collectionView:UICollectionView) -> CGSize
}

public extension SimpleModelCell {
    public static func defaultCell(collectionView:UICollectionView,indexPath:IndexPath,model:ModelType?) -> Self {
        let ident = String(describing: Self.self)
        var cell:Self = collectionView.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! Self
        cell.model = model
        return cell
    }
    
    public static func defaultSupplementaryView(collectionView:UICollectionView,indexPath:IndexPath,kind:String,model:ModelType?) -> Self {
        let ident = String(describing: Self.self)
        var cell:Self = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ident, for: indexPath) as! Self
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
    
    public static func curriedCalculateSize(getModel:@escaping (IndexPath) -> ModelType?) -> (UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize {
        return { collectionView,layout,indexPath in
            return calculateSize(model: getModel(indexPath), collectionView: collectionView)
        }
    }
    
    public static func defaultSection(getModel:@escaping (IndexPath) -> ModelType?,getCount:@escaping SectionCountBlock, collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        updateSection(section: section, getModel: getModel, getCount: getCount, collectionView: collectionView)
        return section
    }
    
    public static func defaultSection(singleModel:@escaping () -> ModelType?, collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        let getCount:SectionCountBlock = {_,_ in 1}
        let getWrapper:(IndexPath) -> ModelType? = {_ in singleModel()}
        updateSection(section: section, getModel: getWrapper, getCount: getCount, collectionView: collectionView)
        return section
    }
    
    public static func defaultSection(items:[ModelType], collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        updateSection(section: section, items: items, collectionView: collectionView)
        return section
    }
    
    //This could possibly be rolled into the one above
    public static func defaultSection(object:ModelType,collectionView:UICollectionView) -> SKCVSectionController {
        let section = SKCVSectionController()
        self.updateSection(section: section, object: object, collectionView: collectionView)
        return section
    }
    
    public static func updateSection(section:SKCVSectionController,getModel:@escaping (IndexPath) -> ModelType?,getCount:@escaping SectionCountBlock, collectionView:UICollectionView) {
        collectionView.register(clazz: self as! AnyClass)
        section.numberOfItemsInSection = getCount
        section.cellForItemAt = { (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = curriedDefaultCell(getModel: getModel)(collectionView,indexPath)
            return cell as! UICollectionViewCell
        }
        
        section.sizeForItemAt = curriedCalculateSize(getModel: getModel)
    }
    
    public static func updateSection(section:SKCVSectionController,object:ModelType,collectionView:UICollectionView) {
        collectionView.register(clazz: self as! AnyClass)
        section.fixedCellCount = 1
        section.cellForItemAt = { (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = curriedDefaultCell(withModel: object)(collectionView,indexPath)
            return cell as! UICollectionViewCell
        }
        
        section.sizeForItemAt = curriedCalculateSize(withModel: object)
    }
    
    public static func updateSection(section:SKCVSectionController,items:[ModelType], collectionView:UICollectionView) {
        updateSection(section: section, getModel: items.getRow, getCount: items.sectionCount, collectionView: collectionView)
    }
    
    public static func updateSectionHeader(section:SKCVSectionController, model:ModelType, kind:String,collectionView:UICollectionView) {
        collectionView.register(clazz: self as! AnyClass, forKind: kind)
        section.viewForSupplementaryElementOfKind = { collectionView,kind,indexPath in
            let header = defaultSupplementaryView(collectionView: collectionView, indexPath: indexPath, kind: kind, model: model)
            return header as! UICollectionReusableView
        }
        section.referenceSizeForHeader = curriedCalculateReferenceSize(withModel: model)
    }
    
    public static func curriedCalculateSize(withModel:ModelType?) -> (UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize {
        return { collectionView,layout,indexPath in
            return calculateSize(model: withModel, collectionView: collectionView)
        }
    }
    
    public static func curriedCalculateReferenceSize(withModel:ModelType?) -> (UICollectionView,UICollectionViewLayout, Int) -> CGSize {
        return { collectionView,layout,section in
            return calculateSize(model: withModel, collectionView: collectionView)
        }
    }
    
    
}
