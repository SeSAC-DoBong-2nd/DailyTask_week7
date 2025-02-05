//
//  PhotoViewController.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/5/25.
//

import UIKit

import PhotosUI
import SnapKit
import Then

final class PhotoViewController: UIViewController {
    
    var onChange: ((UIImage)->Void)?
    var list = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setNav()
        setHierarchy()
        setLayout()
        setUI()
    }
    
    private func setNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(navTapped))
    }
    
    private func setHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        collectionView.do {
            $0.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.id)
            $0.collectionViewLayout = setCollectionViewLayout()
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    private func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: (width - 20)/3, height: 100)
        return layout
    }
    
    @objc
    func navTapped() {
        print(#function)
        print(#function)
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.screenshots, .images]) //필터링 요소 여러개 사용
        config.selectionLimit = 0
        config.selection = .ordered
        config.mode = .default
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

extension PhotoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        
        self.onChange?(list[indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.id, for: indexPath) as! PhotoCollectionViewCell
        
        cell.configureCell(image: list[indexPath.item])
        
        return cell
    }
    
}

extension PhotoViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(#function)
        for i in results {
            if i.itemProvider.canLoadObject(ofClass: UIImage.self) {
                i.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    self.list.append((image as? UIImage)!)
                }
            }
        }
        
        dismiss(animated: true)
    }
    
}

