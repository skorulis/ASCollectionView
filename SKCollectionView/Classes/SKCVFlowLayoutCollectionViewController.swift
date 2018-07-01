//
//  SKCVFlowLayoutCollectionViewController.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 30/6/18.
//

import UIKit

open class SKCVFlowLayoutCollectionViewController: UICollectionViewController {

    public let sections:SKCVSectionCoordinator = SKCVSectionCoordinator()
    public let flowLayout = UICollectionViewFlowLayout();
    
    public init() {
        super.init(collectionViewLayout: flowLayout)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.sections.collectionView = self.collectionView
        
        self.collectionView?.delegate = sections
        self.collectionView?.dataSource = sections
    }

}
