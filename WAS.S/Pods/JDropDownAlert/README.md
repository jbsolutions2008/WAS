# JDropDownAlert

![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/JDropDownAlert.svg?style=flat)](http://cocoapods.org/pods/JDropDownAlert)
![spm](https://img.shields.io/badge/SPM-ready-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/JDropDownAlert.svg?style=flat)](http://cocoapods.org/pods/JDropDownAlert)
[![License](https://img.shields.io/cocoapods/l/JDropDownAlert.svg?style=flat)](http://cocoapods.org/pods/JDropDownAlert)
[![Build Status](https://travis-ci.org/trilliwon/JDropDownAlert.svg?branch=master)](https://travis-ci.org/trilliwon/JDropDownAlert)
[![codecov](https://codecov.io/gh/trilliwon/JDropDownAlert/branch/master/graph/badge.svg)](https://codecov.io/gh/trilliwon/JDropDownAlert)
[![Issues](https://img.shields.io/github/issues/trillione/JDropDownAlert.svg?style=flat)](https://github.com/trillione/JDropDownAlert/issues?state=open)

## JDropDownALert
Simple DropDown Alert View For Any iOS Projects.

# Usage

### Top

```Swift
    let alert = JDropDownAlert()
    alert.alertWith("U can use just title")
    
    alert.didTapBlock = {
      print("Top View Did Tapped")
    }
    
    let alert = JDropDownAlert()
    alert.alertWith(titleString, message: messageString)
    
    alert.didTapBlock = {
      print("Top View Did Tapped")
    }
```

### Top With Directions

```Swift
    let alert = JDropDownAlert(position: .top, direction: .toLeft)
    alert.alertWith(titleString, message: messageString)
    
    alert.didTapBlock = {
      print("Top View Did Tapped")
    }
    
    let alert = JDropDownAlert(position: .top, direction: .toRight)
    alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray, backgroundColor: UIColor.brown)

//  alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray)
//  alert.alertWith(titleString, message: messageString, topLabelColor: UIColor.white)
//  alert.alertWith(titleString, message: messageString)

    
    alert.didTapBlock = {
      print("Top View Did Tapped")
    }
```

### Bottom

```Swift
    let alert = JDropDownAlert(position: .bottom)
    alert.alertWith(titleString, message: messageString)
    
    alert.didTapBlock = {
      print("Bottom Alert View Did Tapped")
    }
```

### Bottom With Directions
```Swift
    let alert = JDropDownAlert(position: .bottom, direction: .toLeft)
    alert.alertWith(titleString, message: messageString)
    
    alert.didTapBlock = {
      print("Bottom Alert View Did Tapped")
    }
    
    let alert = JDropDownAlert(position: .bottom, direction: .toRight)
    alert.alertWith(titleString, message: messageString)
    
    alert.didTapBlock = {
      print("Bottom Alert View Did Tapped")
    }
```

### Different Positions and Animation Directions
```Swift
  enum AlertPosition {
    case top
    case bottom
  }
  
  enum AnimationDirection {
    case toLeft
    case toRight
    case normal
  }
```



## Requirements

+ iOS 8.0 + 
+ swift 3.0
+ Xcode 8.0

## Installation

JDropDownAlert is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JDropDownAlert"
```

Add the JDropDownAlert.swift in to your project.


## Credits

Author
- [trilliwon](https://github.com/trilliwon)

Contributors
- [ppth0608](https://github.com/ppth0608)
- [Dudi00](https://github.com/Dudi00)


##### Any contribution is welcome. Just submit a pull request.

## License

JDropDownAlert is available under the MIT license. See the LICENSE file for more info.


## Demo Gifs

![top alert](https://cloud.githubusercontent.com/assets/14218787/15983592/e208537c-2fe7-11e6-85d5-55ce0abfc798.gif)
![bottom alert](https://cloud.githubusercontent.com/assets/14218787/15983591/e1ec599c-2fe7-11e6-8956-54ae855d868a.gif)
