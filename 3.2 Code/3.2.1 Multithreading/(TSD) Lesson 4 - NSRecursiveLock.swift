import UIKit
import Foundation

var greeting = "Hello, playground"

class RecursiveMutexTest {
  private var mutex = pthread_mutex_t()
  private var attribute = pthread_mutexattr_t()

  init() {
    pthread_mutexattr_init(&attribute)
    pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE)

    pthread_mutex_init(&mutex, &attribute)
  }

  func firstTask() {
    pthread_mutex_lock(&mutex)
    secondTask()
    defer {
      pthread_mutex_unlock(&mutex)
    }
  }

  private func secondTask() {
    pthread_mutex_lock(&mutex)
    print("Finish")
    defer {
      pthread_mutex_unlock(&mutex)
    }
  }
}

let recursive = RecursiveMutexTest()
recursive.firstTask()

let recursiveLock = NSRecursiveLock()

class RecursiveThread:  Thread {
  override func main() {
    recursiveLock.lock()
    print("Thread acquired lock")
    callMe()
    defer {
      recursiveLock.unlock()
    }
    print("Exit main")
  }

  func callMe() {
    recursiveLock.lock()
    defer {
      recursiveLock.unlock()
    }
    print("Exit callMe")
  }
}

let thread = RecursiveThread()
thread.start()

// Finish
// Thread acquired lock
// Exit callMe
// Exit main
