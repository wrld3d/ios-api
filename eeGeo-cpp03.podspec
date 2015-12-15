Pod::Spec.new do |m|

  m.name    = 'eeGeo-cpp03'
  m.version = '##EEGEO_API_VERSION##'

  m.summary          = 'Stunning, Interactive 3D Maps'
  m.description      = 'The eeGeo SDK, a C++03 OpenGL-based library for beautiful and customisable 3D maps. Includes Objective-C bindings for iOS.'
  m.homepage         = 'http://www.eegeo.com'
  m.license          = 'eeGeo SDK License'
  m.author           = { 'eeGeo' => 'support@eegeo.com' }

  m.source = {
    :http => "##EEGEO_API_PACKAGE_PATH##",
    :flatten => true
  }

  m.platform              = :ios
  m.ios.deployment_target = '7.0'

  m.requires_arc = false
  m.source_files = '**/*.{h,m,mm,cpp}'
  m.public_header_files = "api/public/*.h"
  m.vendored_library = 'libapps-on-maps.a', 'libapps-on-maps-sim.a', 'libturbojpeg.a', 'libuv.a', 'libcurl.a'

  m.module_name = 'eeGeo-cpp03'
  m.frameworks = 'QuartzCore', 'CoreLocation', 'MobileCoreServices', 'SystemConfiguration', 'CFNetwork', 'GLKit', 'OpenGLES', 'UIKit', 'Foundation', 'CoreGraphics', 'CoreData'
  m.libraries = 'stdc++','z'
  m.xcconfig = { 
    'OTHER_CPLUSPLUSFLAGS' => '',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++98',
    'CLANG_CXX_LIBRARY' => 'libstdc++' 
  }

  m.dependency 'SMCalloutView', '~> 2.1'

end
