<a href="https://www.wrld3d.com/">
    <img src="https://cdn2.wrld3d.com/wp-content/uploads/2017/04/WRLD_Blue.png"  align="right" height="80px" />
</a>

# WRLD iOS SDK
A framework for displaying beautiful, interactive 3D maps on iOS devices.

This repository contains source code for the Objective-C framework alongside a dev app, intended for developers contributing to the library itself.

If instead you want information on how to integrate a WRLD 3d map view in your iOS app, then follow our [walkthrough guide](https://docs.wrld3d.com/ios/latest/docs/examples/walkthrough/).

The framework is available on [CocoaPods](https://cocoapods.org/pods/wrld).

## Building the SDK

### Requirements
* Latest Xcode (Tested 7.x and 8.x)
* [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

### Building
This section will walk you through the process of getting up and running quickly.

1.  Install CocoaPods as described in the [CocoaPods guide](https://guides.cocoapods.org/using/getting-started.html#getting-started).
2.  Clone this repo: `git clone https://github.com/wrld3d/ios-api.git`
3.  Install dependencies by running `pod install` from the root of the repo.
4.  Obtain a [WRLD API key](https://accounts.wrld3d.com/#/tab-keys) and place it in the [Info.plist](https://github.com/wrld3d/ios-api/blob/master/DevApp/Info.plist#L49) file.
5.  Open, build, and run **ios-sdk.xcworkspace** in Xcode.

**Note:** Run `pod update` followed by `pod install` to update the pod to the latest version if you have already setup your pod as above.

### WRLD API Key 
In order to use the WRLD iOS API, you must sign up for a Digital Twin developer account at https://www.wrld3d.com/pricing/developers. After signing up, you'll be able to create an [API key](https://accounts.wrld3d.com/#/tab-keys) for your apps. 

After signing up for a developer account and creating an API key, add it to the dev app [plist file](https://github.com/wrld3d/ios-api/blob/master/DevApp/Info.plist#L49) as described [above](#getting-started).

If you are creating a new app, or integrating WRLD 3D Maps into an existing app, the API key should be present in the main bundle info dictionary for the key "WrldApiKey" at the time the [WRLDMapView](https://github.com/wrld3d/ios-api/blob/master/src/private/WRLDMapView.mm) is created.

## Status
The WRLD iOS SDK is currently in alpha, and is undergoing active development - we will be expanding with further features and improvements.


## Further information

See our [API documentation](https://docs.wrld3d.com/ios/latest/docs/api/) and [examples](https://docs.wrld3d.com/ios/latest/docs/examples/).

The [example GitHub repository](https://github.com/wrld3d/ios-api-example) contains an open-source iOS app that illustrates the API features.

Questions, comments, or problems? All feedback is welcome - get in touch on the [issues](https://github.com/wrld3d/ios-api/issues) page.

## Contributing
If you wish to contribute to this repo, [pull requests](https://github.com/wrld3d/ios-api/pulls) on GitHub are welcomed.

## License
The WRLD iOS SDK is released under the Simplified BSD License. See the [LICENSE.md](https://github.com/wrld3d/ios-api/blob/master/LICENSE.md) file for details.
