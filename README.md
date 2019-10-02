# KBCachier
> An easy to integrate and use api cache library

![Swift version](https://img.shields.io/badge/swift-5-orange.svg)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
![License](https://img.shields.io/cocoapods/l/BadgeSwift.svg?style=flat)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

This library provides an async image, JSON and Data downloader with cache support. For convenience, Extension for UIImageView has been added. Download Data asynchronously, cache response in memory, set max cache size and more with KBCachier!

## Features
- [x] Cache Image, JSON or any other Data from APIs
- [x] Set maximum cache size
- [x] Parellel requests
- [x] Choose thread for api calls
- [x] Customizable

## Requirements

- iOS 10.0+
- Xcode 10.0
- Swift 5+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `KBCachier` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'KBCachier', :git => 'https://github.com/keshavx11/KBCachier.git', :tag => '0.0.1'
```

```
github "keshavx11/KBCachier"
```

#### Manually
1. Download and drop ```KBCachier``` folder in your project.
2. Congratulations!

## Usage

```swift
import KBCachier

// Configure Cachier
class func configureCachier() {

    // Max cache size 10 MB
    Cachier.shared.isInMemoryCacheEnabled = true
    Cachier.shared.maxCacheSize = 10485760

    // Set log level
    Cachier.shared.logLevel = .warning

    // Set dispatchQueue for making api calls
    Cachier.shared.dispatchQueue = DispatchQueue.global(qos: .userInitiated)

}

// Get JSON data
func getJSON() {
    Cachier.shared.fetchJSONData(forUrl: YOUR_URL, completion: { (response: Any) in
    
    }, error: { errorString in

    })
}

// Download Image and set to image view directly
func downloadImage() {
  self.downloadTask = self.imageView.setImage(withUrl: url, placeholder: nil, completion: { (success) in

  })
}

// Cancel Download task
self.downloadTask.cancel()
    
```

## LICENSE

MIT License (see `LICENSE`)

## Contribute

We would love it if you can contribute to **KBCachier**

## Author

Keshav Bansal – [@LinkedIn](https://www.linkedin.com/in/keshav-bansal-9a290bb2/) – keshav_x11@yahoo.co.in



[swift-image]:https://img.shields.io/badge/swift-swift%204-yellow.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
