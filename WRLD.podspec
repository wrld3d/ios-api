#
# run `pod spec lint WRLD.podspec' before submitting.
#

Pod::Spec.new do |s|

  s.name             = 'WRLD'
  s.version          = '##WRLD_IOS_SDK_VERSION##'
  s.summary          = '3D maps and indoor maps for iOS'

  s.description      = 'Display 3D outdoor and indoor maps and markers using OpenGL'

  s.homepage         = 'https://github.com/wrld3d/ios-api'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD 2-Clause', :file => 'LICENSE.md' }
  s.author           = { 'WRLD' => 'support@wrld3d.com' }
  s.documentation_url = 'https://docs.eegeo.com/ios/latest/docs/api/'

  s.source = {
    :http => "https://s3.amazonaws.com/eegeo-static/wrld-ios-sdk/builds/wrld-ios-sdk-v#{s.version.to_s}.zip",
    :flatten => true
  }

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true


  s.vendored_frameworks = 'Wrld.framework', 'WrldWidgets.framework'
  s.module_name = 'Wrld'
end

