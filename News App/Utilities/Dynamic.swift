//
//  Dynamic.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import Foundation

class Dynamic<T> {
typealias Listener = (T) -> Void
var listener: Listener?

func bind(listener: Listener?) {
    self.listener = listener
}

func bindAndFire(listener: Listener?) {
    self.listener = listener
    listener?(value)
}

var value: T {
    didSet {
        listener?(value)
    }
}

init(_ v: T) {
    value = v
}}
