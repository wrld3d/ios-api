![eeGeo](http://cdn2.eegeo.com/wp-content/uploads/2015/06/wide_eegeo_logo_hero.jpg)

# eeGeo 3D Maps iOS API

Objective-C iOS bindings for the [eeGeo SDK](http://www.eegeo.com/developers/), a C++11 OpenGL-based library for [beautiful and customisable 3D maps](http://www.eegeo.com). 

This document provides the information you need to quickly get up and running in a pre-made app, which demonstrates how an application can use the eeGeo 3D maps API to display beautiful 3D maps. The example can be used as the basis for your own app, or can be used as a reference when integrating the eeGeo 3D map into an existing app. We'll also cover how to get an API key, present an overview of the API types, and explain the process for contributing changes to the API.


## Getting Started 

This section will walk you through the process of getting up and running quickly.

### CocoaPods

CocoaPods is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like the eeGeo 3D Maps API in your projects. See the [CocoaPods guide](https://guides.cocoapods.org/) for information about CocoaPods (including installation instructions).

The [eeGeo 3D Maps API CocoaPod](https://cocoapods.org/pods/eegeo) can be used by your project by including the 'eeGeo' pod in your Podfile. This saves having to manually configure and maintain an XCode project which includes the API.

#### Minimal Podfile

A minimal Podfile looks like:

```ruby
target 'MyApp' do
  pod 'eeGeo'
end
```

### iOS API Example App

The [iOS API Example app](https://github.com/eegeo/ios-api-example) serves two purposes. Firstly, it is a minimal app that can be used as a reference for using the API in practice, or as a basis for more complex apps. Secondly, it serves as a demonstration of the use of the eeGeo 3D Maps alongside Apple's MapKit, and Google Maps. 

The intention of the eeGeo 3D Maps API is that it is simple to use and can be dropped in to an app unobtrusively, so it uses common idioms for mapping APIs. The example app provides a concrete demonstration of this by setting up the same scene in all three maps. We also take the opportunity to show some of the dynamic features of our maps to change the look and feel of the environment. 

**To get started with the example app:**

1. Install CocoaPods as described in the [CocoaPods guide](https://guides.cocoapods.org/).
2. Clone the repo: **git clone git@github.com:eegeo/ios-api-example.git**.
3. Install the eeGeo pod, and other app dependencies by running **pod install** from the repo root.
4. Open and build the **eeGeoApiExample.xcworkspace**.
5. Obtain an [eeGeo API key](https://www.eegeo.com/developers/apikeys) and put it in the [plist file](https://github.com/eegeo/ios-api-example/blob/master/ExampleApp/eeGeoApiExample-Info.plist#L6).

#### Example App Podfile

The example app Podfile contains the eeGeo pod, as well as other dependencies required for the app. Notice that we do not specify a version for the eeGeo pod; this means that the app will get the latest eeGeo API version when running **pod update**.

```ruby
target :eeGeoApiExample do

	platform :ios, "7.0"

	pod 'eeGeo'
	pod 'GoogleMaps', '1.10.1'
	pod 'FPPopover', '1.4.1'
	
end
```


### API Key 

In order to use the eeGeo 3D Maps API, you must sign up for a free developer account at https://www.eegeo.com/developers. After signing up, you'll be able to create an [API key](https://www.eegeo.com/developers/apikeys) for your apps. 

After signing up for a developer account and creating an API key, add it to the example app [plist file](https://github.com/eegeo/ios-api-example/blob/master/ExampleApp/eeGeoApiExample-Info.plist#L6) as described in the previous section.

If you are creating a new app, or integrating eeGeo 3D Maps into an existing app, the API key should be present in the main bundle info dictionary for the key "eeGeoMapsApiKey" at the time the [EGMapView](https://github.com/eegeo/ios-api/blob/master/src/private/EGMapView.mm) is created.


## API Overview 

There are three main types that the app interacts with when using the eeGeo iOS API: EGMapView, EGMapDelegate, and EGMapApi.

#### [EGMapView](https://github.com/eegeo/ios-api/blob/master/src/public/EGMapView.h)

The EGMapView is a UIView subclass that can be added to the application view hierarchy. It contains the surface that the eeGeo 3D map is rendered to. Adding a EGMapView to the view hierarchy begins the process of constructing the EGMapApi instance, which will be made available to the application via the EGMapDelegate delegate.

The EGMapView is internally responsible for managing the streaming and drawing of map data, as well as processing touch input to move the camera. From within a ViewController implementing the EGMapDelegate protocol, you can add a view:

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eegeoMapView = [[[EGMapView alloc] initWithFrame:self.view.bounds] autorelease];
    self.eegeoMapView.eegeoMapDelegate = self;
    [self.view insertSubview:self.eegeoMapView atIndex:0];
}
```

#### [EGMapDelegate](https://github.com/eegeo/ios-api/blob/master/src/public/EGMapDelegate.h)

Adding an EGMapDelegate is important, as the main EGMapApi instance is provided to the app via the delegate. The method to do this is the only required method in the delegate protocol. When the API is ready for use by the app, the EGMapView will call the **eegeoMapReady** method, which should be implemented like so:

```objective-c
- (void)eegeoMapReady:(id<EGMapApi>)api
{
    self.eegeoMapApi = api;

    // App code to handle the API becoming available...
}
```

The EGMapDelegate also provides optional methods to handle events generated by the map, such as the selection and deselection of annotations, as well as various options to customise the behaviour of the map.


#### [EGMapApi](https://github.com/eegeo/ios-api/blob/master/src/public/EGMapApi.h) 

The EGMapApi is the main interface through which the app can manipulate the map.

###### Annotations

Adding an annotation is simple:

```
EGPointAnnotation* annotation = [[[EGPointAnnotation alloc] init] autorelease];
annotation.coordinate = CLLocationCoordinate2DMake(37.794851, -122.402650);
annotation.title = @"Three Embarcadero";
annotation.subtitle = @"(Default Callout)";
[self.eegeoMapApi addAnnotation:annotation];
```

This results in an annotation being added to the map, with a default callout when selected. The default callout is implemented using the [SMCalloutView](https://github.com/nfarina/calloutview) library, which resembles the familiar built-in MapKit callout. We can handle the selection of the annotation by implementing the EGMapDelegate method:

```
- (void)didSelectAnnotation:(id<EGAnnotation>)annotation
{
    // Add a nice left callout accessory.
    EGAnnotationView* view = [self.eegeoMapApi viewForAnnotation:annotation];
    view.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    printf("Selected annotation with title: %s\n", [[annotation title] UTF8String]);
}
```

Visually, this results in something like:

![Annotation](http://cdn2.eegeo.com/wp-content/uploads/2015/09/annotation.jpg)


###### Themes

The presentation of the map can be changed using "themes". Themes allow environment textures, lighting parameters, and overlay effects to be modified allowing for significant variation in how the map looks. A collection of preset themes are included, but new themes can also be created. Changing the theme to use an existing preset is simple:

```
EGMapTheme* mapTheme = [[[EGMapTheme alloc] initWithSeason: EGMapThemeSeasonSummer
                                                   andTime: EGMapThemeTimeDay
                                                andWeather: EGMapThemeWeatherClear] autorelease];


[self.eegeoMapApi setMapTheme: mapTheme];
```

The Summer/day/clear theme looks something like:

![SummerDayTheme](http://cdn2.eegeo.com/wp-content/uploads/2015/09/summer_day_theme.jpg)

We can vary the time of day:

```
EGMapTheme* mapTheme = [[[EGMapTheme alloc] initWithSeason: EGMapThemeSeasonSummer
                                                   andTime: EGMapThemeTimeNight
                                                andWeather: EGMapThemeWeatherClear] autorelease];


[self.eegeoMapApi setMapTheme: mapTheme];
```

The Summer/night/clear theme looks like:

![SummerNightTheme](http://cdn2.eegeo.com/wp-content/uploads/2015/09/summer_night_theme.jpg)


We think that by using map themes, developers can achieve a distinctive and unique style for their maps. 

To see more of the iOS API, take a look at the [Example App View Controller](https://github.com/eegeo/ios-api-example/blob/master/ExampleApp/EegeoMapsContainerViewController.m). To see the eeGeo 3D maps in action, clone the [iOS API Example](https://github.com/eegeo/ios-api-example) and run the app.

See the [eeGeo CocoaDocs](http://cocoadocs.org/docsets/eeGeo/) page for documentation generated from inline headerdoc comments.

## Support

If you **need help**, contact [support@eegeo.com](mailto:support@eegeo.com). Bug reports or feature requests are also accepted. We welcome contributions - if you **want to contribute**, submit a pull request using the process described in the following section.


## Contributing 

The following step by step guide details the process for contributing to the iOS API.

* First clone the [iOS API source repo](https://github.com/eegeo/ios-api). 
* Download the latest [eeGeo SDK](http://s3.amazonaws.com/eegeo-static/sdk.package.ios.cpp11.tar.gz).
* Link the API and the SDK in the [iOS-api-example](https://github.com/eegeo/ios-api-example) XCode project.
* Expose additional functionality as required, demonstrating its use in the example app.
* Submit a PR to the [iOS API source repo](https://github.com/eegeo/ios-api) containing the change, submit a PR to the [iOS-api-example](https://github.com/eegeo/ios-api-example) repo demonstrating its use.

## License

The eeGeo 3D Maps API is released under the Eegeo Platform SDK Evaluation license. See LICENSE.md for details.
