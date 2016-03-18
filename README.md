<a href="http://www.eegeo.com/">
    <img src="http://cdn2.eegeo.com/wp-content/uploads/2016/03/eegeo_logo_quite_big.png" alt="eeGeo Logo" title="eegeo" align="right" height="80px" />
</a>

# eeGeo 3D Maps iOS API

- [Getting started](#getting-started)
    - [eeGeo API Key](#eegeo-api-key)
- [Contributing](#contributing)
- [API Overview](#api-overview)
    - [EGMapView](#egmapview)
    - [EGMapDelegate](#egmapdelegate)
    - [EGMapAPI](#egmapapi)
        - [Annotations](#annotations)
        - [Themes](#themes)
- [Support](#support)
- [License](#license)

Objective-C iOS bindings for the [eeGeo SDK](http://www.eegeo.com/developers/), a C++11 OpenGL-based library for [beautiful and customisable 3D maps](http://www.eegeo.com).

The eeGeo 3D Maps API is simple to use and can be dropped unobtrusively into an app. It follows common idioms for mapping APIs, so should be familiar to anyone with prior experience in this area.

## Getting Started 

The easiest way to get started is with the [eeGeo iOS API example app](https://github.com/eegeo/ios-api-example), which demonstrates the usage of eeGeo's 3D maps in an iOS application. Instructions for getting started can be found under that repo's [README](https://github.com/eegeo/ios-api-example/blob/master/README.md#getting-started) file.

### eeGeo API Key 

In order to use the eeGeo 3D Maps API, you must sign up for a free developer account at https://www.eegeo.com/developers. After signing up, you'll be able to create an [API key](https://www.eegeo.com/developers/apikeys) for your apps. 

If you are creating a new app, or integrating eeGeo 3D Maps into an existing app, the API key should be present in the main bundle info dictionary for the key "eeGeoMapsApiKey" at the time the [EGMapView](https://github.com/eegeo/ios-api/blob/master/src/private/EGMapView.mm) is created.

## Contributing 

The following step by step guide details the process for contributing to the iOS API.

1. **Download the following:**
    * Clone this repo: `git clone git@github.com:eegeo/ios-api.git`
    * Clone the [ios-api-example](https://github.com/eegeo/ios-api-example) repo: `git clone git@github.com:eegeo/ios-api-example.git`
    * Download the latest [eeGeo SDK](http://s3.amazonaws.com/eegeo-static/sdk.package.ios.cpp11.tar.gz).

2. **Setup the project:**
    * Modify the Podfile in the example app to remove the eeGeo pod and add the SMCalloutView pod. It should look like this:
        ```ruby
        target :eeGeoApiExample do
        
            platform :ios, "7.0"
        
            pod 'SMCalloutView', '~> 2.1'
            pod 'GoogleMaps', '1.10.1'
            pod 'FPPopover', '1.4.1'
        end
        ```
    * Build the example app [as normal](https://github.com/eegeo/ios-api-example#getting-started).
    * Drag the ios-api and the eeGeo SDK into the Xcode workspace.
        ![Dragging in the ios-api and SDK](http://cdn2.eegeo.com/wp-content/uploads/2016/03/DraggingSources.gif)
    * Add both to the include path of the example app, and add the SDK to the library path.

3. **Make a change**
    * Expose additional functionality as required.
    * Submit a pull request to this repo containing the new functionality.
    * Submit a pull request to [ios-api-example](https://github.com/eegeo/ios-api-example) demonstrating the new functionality in the example app.

## API Overview 

There are three main types that the app interacts with when using the eeGeo iOS API, described below: EGMapView, EGMapDelegate, and EGMapApi.

For more detailed documentation of the API as a whole, see the [eeGeo CocoaDocs](http://cocoadocs.org/docsets/eeGeo/) page.

### [EGMapView](https://github.com/eegeo/ios-api/blob/master/src/public/EGMapView.h)

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

### [EGMapDelegate](https://github.com/eegeo/ios-api/blob/master/src/public/EGMapDelegate.h)

Adding an EGMapDelegate is important, as the main EGMapApi instance is provided to the app via the delegate. The method to do this is the only required method in the delegate protocol. When the API is ready for use by the app, the EGMapView will call the **eegeoMapReady** method, which should be implemented like so:

```objective-c
- (void)eegeoMapReady:(id<EGMapApi>)api
{
    self.eegeoMapApi = api;

    // App code to handle the API becoming available...
}
```

The EGMapDelegate also provides optional methods to handle events generated by the map, such as the selection and deselection of annotations, as well as various options to customise the behaviour of the map.


### [EGMapApi](https://github.com/eegeo/ios-api/blob/master/src/public/EGMapApi.h) 

The EGMapApi is the main interface through which the app can manipulate the map. It provides methods for drawing polygons, displaying annotations, and changing the theme of the map.

#### Annotations

Adding an annotation is simple:

```
EGPointAnnotation* annotation = [[[EGPointAnnotation alloc] init] autorelease];
annotation.coordinate = CLLocationCoordinate2DMake(37.794851, -122.402650);
annotation.title = @"Three Embarcadero";
annotation.subtitle = @"(Default Callout)";
[self.eegeoMapApi addAnnotation:annotation];
```

The annotation added to the map will show a default callout when selected. The default callout is implemented using the [SMCalloutView](https://github.com/nfarina/calloutview) library, which resembles the familiar built-in MapKit callout. We can handle the selection of the annotation by implementing the EGMapDelegate method:

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


#### Themes

The presentation of the map can be changed depending on the theme being used. Themes allow environment textures, lighting parameters, and overlay effects to be modified allowing for significant variation in how the map looks. A collection of preset themes are included, allowing the season, weather, and time of day to be altered. New themes can also be created.

Changing the theme to use an existing preset is simple. Here are a couple of examples:

```objc
// Spring, dawn, rainy weather
EGMapTheme* mapTheme = [[[EGMapTheme alloc] initWithSeason: EGMapThemeSeasonSpring
                                                   andTime: EGMapThemeTimeDawn
                                                andWeather: EGMapThemeWeatherRainy] autorelease];

[self.eegeoMapApi setMapTheme: mapTheme];
```
```objc
// Summer, day-time, clear weather
EGMapTheme* mapTheme = [[[EGMapTheme alloc] initWithSeason: EGMapThemeSeasonSummer
                                                   andTime: EGMapThemeTimeDay
                                                andWeather: EGMapThemeWeatherClear] autorelease];

[self.eegeoMapApi setMapTheme: mapTheme];
```

Many other presets are available, allowing developers to create a distinctive and unique style for their maps.

![Four different seasons, weathers, and times of day](http://cdn2.eegeo.com/wp-content/uploads/2016/03/eegeo-four-seasons-themes.jpg)

## Support

If you have any questions, bug reports, or feature requests, feel free to submit to the [issue tracker](https://github.com/eegeo/ios-api/issues) for this repository. Alternatively, you can contact us at [support@eegeo.com](mailto:support@eegeo.com).

## License

The eeGeo 3D Maps API is released under the Eegeo Platform SDK Evaluation license. See LICENSE.md for details.
