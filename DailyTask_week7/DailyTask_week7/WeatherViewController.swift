//
//  WeatherViewController.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/3/25.
//

import UIKit

import MapKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    private lazy var locationManager = CLLocationManager()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.text = "날씨 정보를 불러오는 중..."
        return label
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [mapView, weatherInfoLabel, currentLocationButton, refreshButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    private func setDelegate() {
        locationManager.delegate = self
    }
    
    private func setupActions() {
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
}

private extension WeatherViewController {
    
    func checkDevicelocationAuth() {
        print(#function)
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let locationAuth: CLAuthorizationStatus
                if #available(iOS 14.0, *) {
                    locationAuth = self.locationManager.authorizationStatus
                } else {
                    locationAuth = CLLocationManager.authorizationStatus()
                }
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuth(status: locationAuth)
                }
            } else {
                print("권한 설정해줘~")
                print("설정 창으로 이동!")
            }
        }
    }
    
    func checkCurrentLocationAuth(status: CLAuthorizationStatus) {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            print("checkLocationAuthStatus notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            //위치 권한 거부 시: 도봉 캠퍼스가 맵뷰 중심으로.
            print("checkLocationAuthStatus denied")
            let coordinate = CLLocationCoordinate2D(latitude: 37.6545021055909, longitude: 127.049672533607)
            setRegionAndAnnotation(coordinate: coordinate)
        case .authorizedWhenInUse:
            print("checkLocationAuthStatus authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        default:
            print("오류 출동")
        }
    }
    
    ///위치 설정 이동 alert 표시
    func showAlertAboutLocationSetting() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요" ,preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "27OE O5", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        let cancel = UIAlertAction (title: "#1", style: .cancel)
        alert.addAction (goSetting)
        alert.addAction (cancel)
        present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Actions
    @objc
    func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        print(#function)
    }
    
    @objc
    func refreshButtonTapped() {
        // 날씨 새로고침 구현
        print(#function)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    //아이폰 고유 위치권한 값 변경시.
    //iOS 14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDevicelocationAuth()
    }
    
    //아이폰 고유 위치권한 값 변경시.
    //iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
    }
    
    //사용자 위치 가져오기 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print()
        guard let coordinate = locations.last?.coordinate
        else { return print("guard let region error") }
        setRegionAndAnnotation(coordinate: coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    //사용자 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
        
    }
    
}
