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
    
    private var currentAnnotation: MKPointAnnotation?
    private var isRefresh = true
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
    
    private let tempLabel = UILabel()
    private let tempMinLabel = UILabel()
    private let tempMaxLabel = UILabel()
    private let humidityLabel = UILabel()
    private let speedLabel = UILabel()
    
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
        
        [tempLabel, tempMinLabel, tempMaxLabel, humidityLabel, speedLabel].forEach {
            view.addSubview($0)
            $0.setLabelUI("notYet", font: .systemFont(ofSize: 14, weight: .semibold))
            $0.isHidden = true
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
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(weatherInfoLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        tempMinLabel.snp.makeConstraints {
            $0.top.equalTo(tempLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(tempLabel.snp.centerX)
        }
        
        tempMaxLabel.snp.makeConstraints {
            $0.top.equalTo(tempMinLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(tempLabel.snp.centerX)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalTo(tempMaxLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(tempLabel.snp.centerX)
        }
        
        speedLabel.snp.makeConstraints {
            $0.top.equalTo(humidityLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(tempLabel.snp.centerX)
        }
    }
    
    private func setDelegate() {
        locationManager.delegate = self
        mapView.delegate = self
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
                //디바이스 위치 서비스 off 상태
                DispatchQueue.main.async {
                    let coordinate = CLLocationCoordinate2D(latitude: 37.6545021055909, longitude: 127.049672533607)
                    self.setRegionAndAnnotation(coordinate: coordinate, isValidLocationAuth: false)
                }
            }
        }
    }
    
    func checkCurrentLocationAuth(status: CLAuthorizationStatus) {
        print(#function)
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            print("checkLocationAuthStatus notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            //앱 내 위치 권한 거부 시: 도봉 캠퍼스가 맵뷰 중심으로.
            print("checkLocationAuthStatus denied")
            //현위치를 눌렀을 때만 alert이 동작하도록 isRefresh 변수 활용
            if !isRefresh {
                showAlertAboutLocationSetting()
                print("before isRefresh: \(isRefresh)")
                isRefresh = true
                print("after isRefresh: \(isRefresh)")
            }
        case .authorizedWhenInUse:
            print("checkLocationAuthStatus authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        default:
            print("오류 출동")
        }
    }
    
    ///위치 설정 이동 alert 표시
    func showAlertAboutLocationSetting() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요." ,preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정 창 이동", style: .default) { _ in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        let cancel = UIAlertAction (title: "취소", style: .destructive)
        alert.addAction (cancel)
        alert.addAction (goSetting)
        present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(coordinate: CLLocationCoordinate2D, isValidLocationAuth: Bool = true) {
        //현재 위치 날씨 받아오기
        getWeatherAPIResponse(lat: coordinate.latitude, lon: coordinate.longitude)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        mapView.setRegion(region, animated: true)
        
        //이전에 등록된 핀이 있다면 삭제
        if currentAnnotation != nil {
            guard let currentAnnotation else { return }
            mapView.removeAnnotation(currentAnnotation)
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        //LocationAuth 값에 따라 핀 title 분기 처리
        annotation.title = isValidLocationAuth ? "내 위치" : "도봉캠퍼스"
        mapView.addAnnotation(annotation)
        currentAnnotation = annotation
    }
    
    func getWeatherAPIResponse(lat: Double, lon: Double) {
        let request = DTO.WeatherRequestModel(lat: lat, lon: lon)
        NetworkManager.shared.getWeatherAPI(apiHandler: .getWeatherAPI(request: request), responseModel: DTO.WeatherResponseModel.self) { result in
            switch result {
            case .success(let success):
//                print("success: \(success)")
                self.configureWeatherUI(result: success)
            case .failure(let failure):
                print("failure: \(failure)")
            }
        }
    }
    
    func configureWeatherUI(result: DTO.WeatherResponseModel) {
        weatherInfoLabel.isHidden = true
        [tempLabel, tempMinLabel, tempMaxLabel, humidityLabel, speedLabel].forEach {
            $0.alpha = 0
            $0.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            tempLabel.text = "현재 온도: " + String(result.main.temp ?? 0)
            tempMinLabel.text = "최저 온도: " + String(result.main.tempMin ?? 0)
            tempMaxLabel.text = "최고 온도: " + String(result.main.tempMax ?? 0)
            humidityLabel.text = "습도: " + String(result.main.humidity ?? 0) + "%"
            speedLabel.text = "풍속: " + String(result.wind.speed ?? 0)
            
            [tempLabel, tempMinLabel, tempMaxLabel, humidityLabel, speedLabel].forEach {
                $0.alpha = 1
            }
        }
        
    }
    
    // MARK: - Actions
    @objc
    func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        print(#function)
        isRefresh = false
        checkDevicelocationAuth()
    }
    
    @objc
    func refreshButtonTapped() {
        // 날씨 새로고침 구현
        print(#function)
        //현재 혹은 도봉캠퍼스에 대한 날씨를 불러와야 하므로 위치 권한 여부를 다시 살피고,
        //  이후 분기처리에 알맞게 위치 값을 불러와 날씨를 조회 후 UI에 세팅 (no alert)
        checkDevicelocationAuth()
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
    //해당 함수는 iOS GPS가 더 정확한 정보를 가져오고자 초기 실행시 횟수가 다방면으로 발생.
    //어떻게 해결해야할까
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        guard let coordinate = locations.last?.coordinate
        else { return print("guard let region error") }
        locationManager.stopUpdatingLocation()
        setRegionAndAnnotation(coordinate: coordinate)
    }
    
    //사용자 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
        
    }
    
}

extension WeatherViewController: MKMapViewDelegate {
    
}
