#  GameCatalog
 

This Client fetches a videogames catalog where you can see prices, newest ones and also filter them.

## App Architecture

- This Project was built with **MVVM** Architecture using **Reactive Patterns**
- In order to implement a precise layout this client uses an Dependency called **Snapkit** ([https://blog.pusher.com/mvvm-ios/]()).
- Included **CoreData** as Persistency Manager
- Using XCTest for Unit Tests

## Dependencies (Using CocoaPods)
- **SnapKit**: Used for Programatic Layout Design ([]())
- **Moya**: Used for creating a Networking layer ([https://github.com/Moya/Moya]())
- **Kingfisher**: Image dowloader client (https://github.com/onevcat/Kingfisher!)
- **RxSwift**: Implementation of reactive patterns in app ([https://github.com/ReactiveX/RxSwift]())

## Flow Diagram

![](fetchGamesDiagram.png)
