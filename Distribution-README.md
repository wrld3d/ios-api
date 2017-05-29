<a href="https://www.wrld3d.com/">
    <img src="https://cdn2.wrld3d.com/wp-content/uploads/2017/04/WRLD_Blue.png"  align="right" height="80px" />
</a>

# WRLD iOS SDK
The WRLD iOS SDK is a framework for displaying beautiful, interactive 3D map views in Cocoa Touch apps for iPhone or iPad. Map views can be embedded into apps using iOS 8.0 or above, using Objective-C, or by simply hooking up in Xcode Interface Builder.

For more information, see the [WRLD iOS API documentation page](https://docs.eegeo.com/ios/latest/docs/api/).


## Installing
The WRLD iOS SDK is provided as a dynamic framework. To integrate the SDK with an app, you will need Xcode 7.3 or later.

You can install either using a direct download, or via CocoaPods.

### Install using direct download
1. From the [lastest github release](https://github.com/wrld3d/ios-api/releases/latest) page, download the ```wrld-ios-sdk``` zip file.
2. In Xcode, select your app's project in Project Navigator to display Project Editor. Select the app's target, then on the ```General``` tab, find the  ```Embedded Binaries``` section.
3. Unzip the ```wrld-ios-sdk``` zip file and drag ```WRLD.framework``` into the ```Embedded Binaries``` section. Check "Copy items if needed" in the resulting dialog box, then click "Finish". This links the WRLD.framework with your project.     
4. Obtain a [WRLD API key](#wrldApiKey) and set this in your app's ```Info.plist``` file.


### Install using CocoaPods
* Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).
* Create a Podfile in the root folder of you app project (replacing 'MyAppTargetName' as appropriate for your app)

```ruby
platform :ios, '8.0'

target 'MyAppTargetName' do
  pod 'WRLD'
end
``` 

* In Terminal, run ```pod install```. This will download the SDK and create an ```xcworkspace``` file. Open this file in Xcode.
* Obtain a [WRLD API key](#wrldApiKey) and set this in your app's ```Info.plist``` file.

## <a name="wrldApiKey"></a>WRLD API Key 
In order to use the WRLD iOS API, you must sign up for a [free developer account](https://www.wrld3d.com/developers). 

After signing up, create an [API key](https://www.wrld3d.com/developers/apikeys) (for clarity, this is a token containing 32 characters). The API key is necessary in order to use WRLD map services. It is good practice to create a new API key for each of you apps - this limits the changes necessary should a key need to be revoked. 

To provide your app with an API key, in Xcode, open your app's ```Info.plist``` file (select it in the Project Navigator).


<img style="padding: 0 0 30px 130px" src="https://docs.eegeo.com/ios/latest/static/images/WRLD-iPadMini.png">

## Use a map view in your app
Now that you have the WRLD iOS SDK installed, you are ready to integrate a WRLD 3d map view into your app.

This step-by-step guide shows you how to use Xcode Interface Builder to integrate a WRLD map view into your iOS app. 

### Set your WRLD API key

In Xcode, select your app's ```Info.plist``` file in the Project Navigator.

Add an entry with the columns set as follows:

- Key: ```WrldApiKey```
- Type: ```String```
- Value: [your api key]

<img src="https://docs.eegeo.com/ios/latest/static/images/iOS-PList.gif">

<br>

### Add a map view with Storyboards

1. Select your app's Main.storyboard in Project Navigator.
2. Expand storyboard View Controller Scene to where you want to add the map view.
3. From the Object Library, filter by ``UIView`` and drag a new ```View``` object into your storyboard.
4. Alternatively, to change an existing UIView to display a WRLD map, just select the view in your storyboard.  
5. In the Utilities sidebar, select Identity Inspector.  
6. Change the Class of the view to ```WRLDMapView```.  

<img src="https://docs.eegeo.com/ios/latest/static/images/iOS-CustomClass.gif">


<br>

### Set the start location of your map

1. With the ```WRLDMapView``` still selected, open the Attributes Inspector. 
2. In the Map View section, set the following: 

```
Start Latitude: 37.789069 
Start Longitude: -122.401141
Start Zoom Level: 15
Start Direction: 0
```

This will configure the map view to start in San Francisco, with the top of the view aligned to North.


### Change 'Enable Bitcode' settings

Currently the WRLD iOS SDK does not support [Bitcode](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html#//apple_ref/doc/uid/TP40012582-CH35-SW2).   Depending on the version of Xcode you are using, you may have to disable this in your project settings:

1. Select Build Settings in Project Editor. 
2. Under Build Options ensure that Enable Bitcode is set to ```No```.

<img src="https://docs.eegeo.com/ios/latest/static/images/iOS-EnableBitcode.gif">


### Build and run your app

You're now ready to try out your app. 

1. Select a target device
2. In the toolbar, click the 'Build and the run the current scheme' button.

    <img src="https://docs.eegeo.com/ios/latest/static/images/iOS-SelectDevice.png">

The app will now install and run on your device. If you selected a Simulator iOS target device, Simulator will launch and then run your app.
<img src="https://docs.eegeo.com/ios/latest/static/images/iOS-Simulator.png">

Add an entry with the columns set as follows:
* Key: ```WrldApiKey```
* Type: ```String```
* Value: [your api key]


### Creating a WRLDMapView in code
The walkthough above shows how to use Xcode Interface Builder to embed a WRLDMapView in an iOS app.

A WRLDMapView instance can also be instantiated and added to a view controller using Objective-C - see the following snippet.

```objc
@import Wrld;

@interface ViewController : UIViewController
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WRLDMapView *mapView = [[WRLDMapView alloc] initWithFrame:self.view.bounds];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // set the center of the map and the zoom level
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(37.7858, -122.401)
                        zoomLevel:15
                         animated:NO];
    
    [self.view addSubview:mapView];
}

@end
```

## Status
The WRLD iOS SDK is currently in alpha, and is undergoing active development - we will be expanding with further features and improvements.

## Further information

See our [API documentation](https://docs.wrld3d.com/ios/latest/docs/api/) and [examples](https://docs.wrld3d.com/ios/latest/docs/examples/).

The [example GitHub repository](https://github.com/wrld3d/ios-api-example) contains an open-source iOS app that illustrates the API features.

Questions, comments, or problems? All feedback is welcome - get in touch on the [issues](https://github.com/wrld3d/ios-api/issues) page.


## License
The WRLD iOS SDK is released under the Simplified BSD License. See the [LICENSE.md](https://github.com/wrld3d/ios-api/blob/master/LICENSE.md) file for details.

