//
//  UserViewModel.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/5/25.
//

import Foundation

struct Person {
    let name: String
    let age: Int
}

class UserViewModel {
    
    var person: Observable<[Person]> = Observable([])
    var inputLoadTapped = Observable(())
    var resetButtonTapped = Observable(())
    
    init() {
        inputLoadTapped.bind { _ in
            self.load()
        }
        resetButtonTapped.bind { _ in
            self.reset()
        }
    }
    
    private func load() {
        person.value = [
            Person(name: "James", age: Int.random(in: 20...70)),
            Person(name: "Mary", age: Int.random(in: 20...70)),
            Person(name: "John", age: Int.random(in: 20...70)),
            Person(name: "Patricia", age: Int.random(in: 20...70)),
            Person(name: "Robert", age: Int.random(in: 20...70))
        ]
    }
    
    private func reset() {
        person.value.removeAll()
    }
    
}
