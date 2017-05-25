<a href="https://www.wrld3d.com/">
    <img src="https://cdn2.wrld3d.com/wp-content/uploads/2017/04/WRLD_Blue.png"  align="right" height="80px" />
</a>

# WRLD iOS SDK
The WRLD iOS SDK is a framework for displaying beautiful, interactive 3D map views in Cocoa Touch apps for iPhone or iPad. Map views can be embedded into apps using iOS 8.0 or above, using Objective-C, or by simply hooking up in Xcode Interface Builder.

For more information, see the [WRLD iOS API documentation page](https://docs.eegeo.com/ios/latest/docs/api/).

## Status
The WRLD iOS SDK is currently in alpha, and is undergoing active development. We plan to add more features and improvements in the near future. 
If you have questions, or would like to see a feature for use in your app, please let us know using the [issues page](https://github.com/wrld3d/ios-api/issues).

## Installing
The WRLD iOS SDK is provided as a dynamic framework. To integrate the SDK with an app, you will need Xcode 7.3 or later.

You can install either using CocoaPods, or as a direct download.

### CocoaPods

1. Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).
2. Create a Podfile in the root folder of you app project (replacing 'MyAppTargetName' as appropriate for your app)
```
platform :ios, '8.0'

target 'MyAppTargetName' do
  pod 'WRLD'
end
``` 
3. In Terminal, run ```pod install```. This will download the SDK and create an ```xcworkspace``` file. Open this file in Xcode.
4. Obtain a [WRLD API key](#wrldApiKey) and set this in your app's ```Info.plist``` file.

### Direct download
1. From the [lastest github release](https://github.com/wrld3d/ios-api/releases/latest) page, download the ```wrld-ios-sdk``` zip file.
2. In Xcode, select your app's project in Project Navigator to display Project Editor. Select the app's target, then on the ```General``` tab, find the  ```Embedded Binaries``` section.
3. Unzip the ```wrld-ios-sdk``` zip file and drag ```WRLD.framework``` into the ```Embedded Binaries``` section. Check "Copy items if needed" in the resulting dialog box, then click "Finish". This links the WRLD.framework with your project.     
4. Obtain a [WRLD API key](#wrldApiKey) and set this in your app's ```Info.plist``` file.

## Build your app
Now that you have the WRLD iOS SDK installed, you are ready to start building your app. See our [walkthrough guide](https://docs.eegeo.com/ios/latest/docs/api/walkthrough/).

You can also look at our [examples documentation](https://docs.eegeo.com/ios/latest/docs/examples/) that describes how to interact with the map view using sample code snippets.
We also have an [example project](https://github.com/wrld3d/ios-api-example) available, that collects these sample snippets into an iOS app. 


## <a name="wrldApiKey"></a>WRLD API Key 
In order to use the WRLD iOS API, you must sign up for a [free developer account](https://www.wrld3d.com/developers). 

After signing up, create an [API key](https://www.wrld3d.com/developers/apikeys) (for clarity, this is a token containing 32 characters). The API key is necessary in order to use WRLD map services. It is good practice to create a new API key for each of you apps - this limits the changes necessary should a key need to be revoked. 

To provide your app with an API key, in Xcode, open your app's ```Info.plist``` file (select it in the Project Navigator).

Add an entry with the columns set as follows:
* Key: ```WrldApiKey```
* Type: ```String```
* Value: [your api key]



