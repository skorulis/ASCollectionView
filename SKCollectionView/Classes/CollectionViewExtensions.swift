//
//  CollectionViewExtensions.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 29/6/18.
//

import UIKit

public extension UICollectionView {
    public func register(clazz:AnyClass) {
        let ident = String(describing: clazz)
        register(clazz, forCellWithReuseIdentifier: ident)
    }
    
    public func register(clazz:AnyClass,forKind kind:String) {
        let ident = String(describing: clazz)
        self.register(clazz, forSupplementaryViewOfKind: kind, withReuseIdentifier: ident)
    }
    
    public func dequeueReusableView<T:UICollectionViewCell>(kind:String,indexPath:IndexPath) -> T {
        let ident = String(describing: T.self)
        let view:T = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ident, for: indexPath) as! T
        return view
    }
    
    public func dequeueCell<T:UICollectionViewCell>(indexPath:IndexPath) -> T {
        let ident = String(describing: T.self)
        let cell:T = dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as! T
        return cell
    }
    
}
