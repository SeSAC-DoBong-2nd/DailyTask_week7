//
//  CurrencyViewModel.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/5/25.
//

import Foundation

final class CurrencyViewModel {
    
    let input: Observable<String?> = Observable(nil)
    let output = Observable("환전 결과가 여기에 표시됩니다")
    
    init() {
        input.bind { value in
            self.currencyExchange()
        }
    }
    
    private func currencyExchange() {
        guard let amountText = input.value,
              let amount = Double(amountText) else {
            input.value = "올바른 금액을 입력해주세요"
            return
        }
        
        let exchangeRate = 1350.0 // 실제 환율 데이터로 대체 필요
        let convertedAmount = amount / exchangeRate
        output.value = String(format: "%.2f USD (약 $%.2f)", convertedAmount, convertedAmount)
    }
    
}
