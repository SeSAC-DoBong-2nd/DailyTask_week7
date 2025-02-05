//
//  PhotoCollectionViewCell.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/5/25.
//

import UIKit

import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let id = "PhotoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView = UIImageView()
    
    private func setHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(image: UIImage) {
        imageView.image = image
    }
    
}
