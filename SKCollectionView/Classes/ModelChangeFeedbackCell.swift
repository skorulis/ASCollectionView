//
//  ModelChangeFeedbackCell.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 5/7/18.
//

public protocol ModelChangeFeedbackCell: SimpleModelCell {
    
    var modelDidChangeBlock: ((ModelType) -> ())? {get set}
    
}


public extension ModelChangeFeedbackCell {
    
    public static func willDisplayCellBlock(change:@escaping (ModelType) -> () ) -> (UICollectionView,UICollectionViewCell,IndexPath) -> () {
        let block:(UICollectionView,UICollectionViewCell,IndexPath) -> () = {(collectionView,cell,indexPath) in
            var changeCell = cell as! Self
            changeCell.modelDidChangeBlock = change
        }
        return block
    }
    
}
