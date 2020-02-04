Pod::Spec.new do |m|

  m.name    = 'wrld_cpp_sdk'
  m.version = '0.0.1'

  m.summary          = 'WRLD C++11 SDK'
  m.description      = 'WRLD C++11 SDK'
  m.homepage         = 'http://www.wrld3d.com'
  m.author           = { 'WRLD' => 'support@wrld3d.com' }

  m.source = {
    :http => "http://s3.amazonaws.com/eegeo-static/sdk.package.ios.cpp11.tar.gz",
    :flatten => true
  }

  m.platform              = :ios
  m.ios.deployment_target = '8.0'

  m.source_files = '**/*.h', 'version.txt'
  m.vendored_library = 'libapps-on-maps-cpp11.a', 'libapps-on-maps-cpp11-sim.a', 'libeegeo-api.a', 'libeegeo-api-sim.a', 'libeegeo-api-host.a', 'libeegeo-api-host-sim.a', 'libturbojpeg.a', 'libuv.a', 'libcurl.a'

  m.module_name = 'WrldSdk'
  m.frameworks = 'CoreLocation', 'SystemConfiguration', 'MobileCoreServices', 'GLKit', 'QuartzCore', 'OpenGLES', 'CoreGraphics', 'UIKit'
  m.libraries = 'c++','z'
  m.xcconfig = { 
    'OTHER_CPLUSPLUSFLAGS' => '-DCOMPILE_CPP_11=1',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
    'CLANG_CXX_LIBRARY' => 'libc++' 
  }

end
