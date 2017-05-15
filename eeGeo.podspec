Pod::Spec.new do |m|

  m.name    = 'eeGeo'
  m.version = '##EEGEO_API_VERSION##'
  m.deprecated = true
  m.deprecated_in_favor_of = 'WRLD'
  m.summary          = 'Stunning, Interactive 3D Maps'
  m.description      = 'The eeGeo SDK, a C++11 OpenGL-based library for beautiful and customisable 3D maps. Includes Objective-C bindings for iOS.'
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
  m.vendored_library = 'libapps-on-maps-cpp11.a', 'libapps-on-maps-cpp11-sim.a', 'libturbojpeg.a', 'libuv.a', 'libcurl.a'

  m.module_name = 'eeGeo'
  m.frameworks = 'QuartzCore', 'CoreLocation', 'MobileCoreServices', 'SystemConfiguration', 'CFNetwork', 'GLKit', 'OpenGLES', 'UIKit', 'Foundation', 'CoreGraphics', 'CoreData'
  m.libraries = 'c++','z'
  m.xcconfig = { 
    'OTHER_CPLUSPLUSFLAGS' => '-DCOMPILE_CPP_11=1',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
    'CLANG_CXX_LIBRARY' => 'libc++' 
  }

  m.dependency 'SMCalloutView', '~> 2.1'
end
