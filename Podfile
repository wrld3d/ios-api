# usage: 
# pod install
#
# For internal development, to install development pod building against (private) src of WRLD C++ sdk:
# env WRLD_CPP_SDK_POD=development pod install

platform :ios, '8.0'

target 'WrldSdk' do
    
    project 'ios-sdk'
    
    case ENV['WRLD_CPP_SDK_POD']
	when 'development'
  		pod 'wrld_cpp_sdk', :path => '../../eegeo-mobile/'
	else
  		pod 'wrld_cpp_sdk', :podspec => './wrld_cpp_sdk.podspec'
    end
	
	target 'WrldWidgetsTests' do
		inherit! :search_paths
		pod 'OCMock', '~> 3.4'
	  end

	target 'WrldSearchWidgetTests' do
		inherit! :search_paths
		pod 'OCMock', '~> 3.4'
	end

end
