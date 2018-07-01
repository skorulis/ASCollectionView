//
//  ArrayExtensions.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 1/7/18.
//

public extension Array {
    
    public func getRow(indexPath:IndexPath) -> Element {
        return self[indexPath.row]
    }
    
    public func sectionCount(collectionView:UICollectionView,section:Int) -> Int {
        return self.count
    }
    
}
