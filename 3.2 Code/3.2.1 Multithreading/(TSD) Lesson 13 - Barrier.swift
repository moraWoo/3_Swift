import Foundation

class SafeArray<T> {
  private var array = [T]()
  private let queue = DispatchQueue(label: "new", attributes: .concurrent)

  public func append(_ value: T) {
    queue.async(flags: .barrier) {
    self.array.append(value)
    }
  }

  public var valueArray: [T] {
    var result = [T]()
    queue.sync{
     result = self.array
    }
    return result
  }
}

var arraySafe = SafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { (index) in
    arraySafe.append(index)
}

print("arraySafe: \(arraySafe.valueArray)")
//arraySafe: [0, 2, 1, 3, 4, 5, 6, 7, 8, 9]
print("arraySafeCount: \(arraySafe.valueArray.count)")
//arraySafeCount: 10
