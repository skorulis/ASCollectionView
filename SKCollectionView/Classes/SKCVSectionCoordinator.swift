//
//  SKCVSectionCoordinator.swift
//  SKCollectionView
//
//  Created by Alexander Skorulis on 29/6/18.
//

import UIKit

public class SKCVSectionCoordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var sections = [SKCVSectionController]()
    public weak var collectionView: UICollectionView?
    
    //MARK: Section management
    
    public func add(section:SKCVSectionController) {
        sections.append(section)
    }
    
    public func add(section:SKCVSectionController,after:SKCVSectionController) {
        if sections.contains(section) {
            return
        }
        let index = sections.index(of: after)!
        sections.insert(section, at: index + 1)
    }
    
    public func remove(section:SKCVSectionController) {
        sections = sections.filter { $0 != section }
    }
    
    public var preReloadBlock:(() -> ())?
    
    public func reloadData() {
        self.preReloadBlock?()
        collectionView?.reloadData()
    }
    
    //MARK: UICollectionView overrides
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return sections[indexPath.section].viewForSupplementaryElementOfKind!(collectionView,kind,indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sections[section].collectionView(collectionView,layout:collectionViewLayout,referenceSizeForHeaderInSection:section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sections[section].collectionView(collectionView,layout:collectionViewLayout,referenceSizeForFooterInSection:section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        return section.collectionView(collectionView,cellForItemAt:indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].collectionView(collectionView,layout:collectionViewLayout,sizeForItemAt:indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        section.didSelectItemAt?(collectionView, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sections[indexPath.section].willDisplayCell?(collectionView,cell,indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        sections[indexPath.section].willDisplaySupplementaryView?(collectionView,view,elementKind,indexPath)
    }
    
}
