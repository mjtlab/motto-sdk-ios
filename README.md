<!--
[![CI Status](https://img.shields.io/travis/daybreaker48/mottolib.svg?style=flat)](https://travis-ci.org/daybreaker48/mottolib)
-->
[![Version](https://img.shields.io/cocoapods/v/mottolib.svg?style=flat)](https://cocoapods.org/pods/mottolib)
[![License](https://img.shields.io/cocoapods/l/mottolib.svg?style=flat)](https://cocoapods.org/pods/mottolib)
[![Platform](https://img.shields.io/cocoapods/p/mottolib.svg?style=flat)](https://cocoapods.org/pods/mottolib)


# Guide to Installing the Motto SDK on IOS
* This document contains some initial settings and sources for installing Motto SDK.
* The latest version of Motto SDK is 0.0.6. Please always use the latest version.
* Please refer to the sample project for the full source.

## Xcode setting
### User Script Sandboxing setting
* User Script Sandboxing value must be set to 'No'. App access must be possible for smooth use of Motto SDK. 
* On Xcode 15, this value is set to 'YES' by default (the default is set to 'No' in earlier versions)
> Project setting > Build Settings > Locate User Script Sandboxing and set the value to 'No'.

### App Tracking Transparency setting
* You must use the AppTrackingTransparency framework if your app collects data about end users and shares it with other companies for purposes of tracking across apps and web sites. The AppTrackingTransparency framework presents an app-tracking authorization request to the user and provides the tracking authorization status.
* It is required to use IDFA (Advertising ID), and when this permission is required within the SDK, the Permission Pop-up will be displayed.
* Add the following values to the info.plist file of the project as appropriate. The comments will be displayed in the Permission pop-up.
```xml
<key>NSUserTrackingUsageDescription</key>
<string>App would like to access IDFA for tracking purpose.[This text is an example and is recommended to be changed as appropriate]</string>
```


## Installation 
* mottolib is available through [CocoaPods](https://cocoapods.org).
* To install it, simply add the following line to your Podfile:
```ruby
pod 'mottolib'
```
* Run pod install from the project directory.

## Initialize the Motto-sdk
* To use Motto SDK, initialization is required first.
* A unique ID must be set to identity the user so that the user can receive rewards upon completing Motto's mission.(If there is no replacement ID or code, you must set the ID of an actual member.)
* If you have already collected the Google Advertising ID in the app, please set it. It is optional.
```swift
Motto.uid = [userID]        // user id(or unique value of user)
Motto.adid = [googleAdId]   // google adid
Motto.pubkey = [app-key]    // app key     
```
* Create the Motto SDK from the ViewController that you want to use as follows.
```swift
let viewcontroller = Motto.create()
self.view.addSubview(viewcontroller.view)
        
viewcontroller.view.snp.makeConstraints { make in
    make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
}      
```

## Theme setting
* Choose dark mode, light mode (default: light mode)
```swift
Motto.setIsDarkMode(true)
```
* Setting background-color, main button color (optional)
* The type is UIColor
```swift
Motto.setBackgroundColor(.white)
Motto.setMainColor(.blue)
```

### Postback setting
* The user's campaign participation record is sent to the registered postback URL. (Registration is possible on the company registration website)
* Called using HTTP POST method.
```xml
    pub_key => registered app key
    user_id => user id
    user_reward => reward value
```
* Response: success
```xml
    {
        "result": 1,
        "message": "success"
    }
```
* Response: fail
```xml
    {
        "result": 0,
        "message": "{error message}"
    }
```

### Help: minkyu.joo.mjt@gmail.com



# IOS용 Motto SDK 연동 가이드
* 이 문서는 Motto SDK를 연동하기 위한 초기 설정과 소스 일부를 포함하고 있습니다.
* 현재 IOS용 Motto SDK의 최신버전은 0.0.6 입니다. 항상 최신 버전을 사용해주시길 바랍니다.
* 전체 소스는 샘플 프로젝트를 참조하시길 바랍니다.

## Xcode 프로젝트 설정
### User Script Sandboxing 설정
* User Script Sandboxing 값을 No로 설정해주어야 합니다. Motto SDK의 원활한 사용을 위해서는 앱 접근이 가능해야 합니다. 
* Xcode 15에서는 이 값이 기본적으로 YES로 설정되어 있습니다.(그 이하 버전에서는 기본값이 No로 설정되어 있음)
> 프로젝트 설정 > Build Settings > User Script Sandboxing 을 찾아 값을 No로 설정합니다.

### 앱 추적 투명성 허가(App Tracking Transparency) 받기
* Ios 14.5 이후 버전에서는 타사 소유의 앱과 웹 사이트 전반에서 사용자를 추적하려면 앱에서 사용자에게 허가를 받아야 합니다.
* IDFA(광고아이디)를 사용하기 위해서 필요하며, SDK 내 이 권한이 필요한 시점에서 권한허용팝업을 띄우게 됩니다.
* 프로젝트의 info.plist 파일에 아래의 값을 적절히 추가합니다. 해당 멘트가 권한허용팝업에서 보여지게 됩니다.
```xml
<key>NSUserTrackingUsageDescription</key>
<string>App would like to access IDFA for tracking purpose.[이 텍스트는 예시이며, 적절히 변경하여 사용을 권장합니다]</string>
```


## SDK 설치하기
* Motto SDK는 Cocoapods으로 설치가 가능합니다. [CocoaPods](https://cocoapods.org) 를 참고하세요.
* 앱 podfile에 아래의 라인을 추가해주세요.
```ruby
pod 'mottolib'
```
* 터미널에서 pod install을 실행하면 SDK가 설치됩니다.

## Motto-sdk 소스 연동
* Motto SDK를 연동하기 위해서는 먼저 초기화가 필요합니다.
* 유저가 Motto의 미션을 완료시 보상을 받을 수 있도록 유저를 식별 할 수 있는 유니크한 ID를 설정해야 합니다.(대체할 ID나 코드가 없다면 실제 회원의 ID라도 설정해야합니다.)
* 구글광고 아이디는 앱에서 이미 수집하고 있으시면 설정해주시길 바랍니다.<br>
  더 정확한 사용자 참여를 확인하기 위한 용도로 사용되며 생략하셔도 무방합니다.
```swift
Motto.uid = [userID]        // 유저식별 값(아이디 혹은 유저를 판별할 수 있는 유니크한 값)
Motto.adid = [googleAdId]   // 구글 광고아이디(생략가능)
Motto.pubkey = [앱키]        // 비즈핏에서 발급받은 앱키          
```
* Motto SDK를 사용하고자 하는 ViewController에서 아래와 같이 생성합니다.
```swift
let viewcontroller = Motto.create()
self.view.addSubview(viewcontroller.view)
        
viewcontroller.view.snp.makeConstraints { make in
    make.top.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
}      
```

## 테마 설정 기능
* 다크모드, 라이트모드 설정 (default: 라이트모드)
```swift
Motto.setIsDarkMode(true) //다크모드 설정
```
* 백그라운드, 메인색상 지정 (선택사항)
* 타입은 UIColor 입니다.
```swift
Motto.setBackgroundColor(.white)
Motto.setMainColor(.blue)
```

### 포스트백 설정 기능
* 사용자의 캠페인 참여 기록을 등록된 포스트백 url로 전송합니다. (등록은 업체등록 홈페이지에서 가능)
* HTTP POST 방식으로 호출합니다.
```xml
    pub_key => 등록된 앱 key 값
    user_id => Motto SDK로 전달된 유저 id
    user_reward => 등록된 비율에 따라 계산된 유저포인트 값
```
* Response: 성공시
```xml
    {
        "result": 1,
        "message": "success"
    }
```
* Response: 실패
```xml
    {
        "result": 0,
        "message": "{error message}"
    }
```

### Help: minkyu.joo.mjt@gmail.com
