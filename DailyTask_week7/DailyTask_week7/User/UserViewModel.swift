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
    var addButtonTapped = Observable(())
    var reloadTrigger = Observable(())
    
    init() {
        inputLoadTapped.lazyBind { [weak self] _ in
            guard let self else {return}
            self.load()
            self.reloadDataTrigger()
        }
        
        resetButtonTapped.lazyBind { [weak self] _ in
            guard let self else {return}
            self.reset()
            self.reloadDataTrigger()
        }
        
        addButtonTapped.lazyBind { [weak self] _ in
            guard let self else {return}
            self.add()
            self.reloadDataTrigger()
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
    
    private func add() {
        let names = ["James", "Mary", "John", "Patricia", "Robert", "Jennifer", "Michael", "Linda", "William", "Elizabeth", "David", "Barbara", "Richard", "Susan", "Joseph", "Jessica", "Thomas", "Sarah", "Charles", "Karen"]
        let user = Person(name: names.randomElement()!, age: Int.random(in: 20...70))
        person.value.append(user)
    }
    
    private func reloadDataTrigger() {
        reloadTrigger.value = ()
    }
    
}
