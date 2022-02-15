//
//  CombineExtension.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/14/22.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
  mutating func cancelAll() {
    forEach { $0.cancel() }
    removeAll()
  }
}
