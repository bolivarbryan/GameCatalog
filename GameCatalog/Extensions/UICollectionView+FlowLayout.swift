import UIKit

extension UICollectionView {

    static var collectionViewLayout: UICollectionViewFlowLayout = {
        let cellWidth = 110
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 11, left: 27, bottom: 0, right: 11)
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 11;
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 50)
        layout.scrollDirection = .horizontal
        return layout
    }()

    static var verticalCollectionViewLayout: UICollectionViewFlowLayout = {
        let cellWidth = (UIScreen.main.bounds.width/2.5) - 2.5
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 27)
        layout.minimumInteritemSpacing = 2;
        layout.minimumLineSpacing = 2;
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 50)
        layout.scrollDirection = .vertical
        return layout
    }()
}
