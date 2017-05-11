#
# run `pod spec lint Wrld-iOS-SDK.podspec' before submitting.
#

Pod::Spec.new do |s|

  semanticVersion = '##WRLD_IOS_SDK_VERSION##'
  buildNumber = '##WRLD_IOS_SDK_BUILD_NUMBER##'

  s.name             = 'Wrld-iOS-SDK'
  s.version          = semanticVersion
  s.summary          = 'Dynamic 3D maps for iOS'

  s.description      = 'Display 3D outdoor and indoor maps and markers using OpenGL'

  s.homepage         = 'https://github.com/eegeo/ios-api'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD 2-Clause', :file => 'LICENSE.md' }
  s.author           = { 'eeGeo' => 'support@eegeo.com' }
  s.social_media_url  = 'https://twitter.com/eegeo'

  s.source = {
    :http => "https://s3.amazonaws.com/eegeo-static/wrld-ios-sdk/builds/test/wrld-ios-sdk-v#{s.version.to_s}%2b#{buildNumber.to_s}.zip",
    :flatten => true
  }


  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true


  s.vendored_frameworks = 'Wrld.framework', 'WrldWidgets.framework'
  s.module_name = 'Wrld'
end

