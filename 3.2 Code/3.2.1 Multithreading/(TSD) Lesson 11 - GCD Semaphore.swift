//семафор может принимать несколько потоков сразу
//mutex может принимать только один поток

import Foundation
let queue = DispatchQueue(label: "TSD", attributes: .concurrent)

let semaphore = DispatchSemaphore(value: 1)

queue.async {
  semaphore.wait() //-1
  sleep(3)
  print("method 1")
  semaphore.signal()
}

queue.async {
  semaphore.wait() //-1
  sleep(3)
  print("method 2")
  semaphore.signal()
}

queue.async {
  semaphore.wait() //-1
  sleep(3)
  print("method 3")
  semaphore.signal()
}

//=======
import Foundation

let sem = DispatchSemaphore(value: 1)

DispatchQueue.concurrentPerform(iterations: 10) { (id: Int) in
  sem.wait(timeout: DispatchTime.distantFuture)
  sleep(1)
  print("Block", String(id))
  sem.signal()
}

//=======

import Foundation

class SemaphoreTest {
  private let semaphore = DispatchSemaphore(value: 1)
  private var array = [Int]()
  private func methodWork(_ id: Int) {
    semaphore.wait()
    array.append(id)
    print("test array: \(array.count)")
    Thread.sleep(forTimeInterval: 1)
    semaphore.signal() // +1
  }

  public func startAllThread() {
    DispatchQueue.global().async {
      self.methodWork(111)
    }

        DispatchQueue.global().async {
      self.methodWork(123123)
    }

        DispatchQueue.global().async {
      self.methodWork(1132421)
    }

        DispatchQueue.global().async {
      self.methodWork(4343)
    }
  }
}

let semaphoreTest = SemaphoreTest()
semaphoreTest.startAllThread()

// test array: 1
// test array: 2
// test array: 3
// test array: 4
