//
//  WordCounterViewModel.swift
//  DailyTask_week7
//
//  Created by 박신영 on 2/5/25.
//

import Foundation

final class WordCounterViewModel {
    
    let input: Observable<Int> = Observable(0)
    let output = Observable("현재까지 0글자 작성중")
    
    init() {
        input.bind { [weak self] _ in
            self?.bindWordCounter()
        }
    }
    
    private func bindWordCounter() {
        output.value = "현재까지 \(input.value)글자 작성중"
    }
}
