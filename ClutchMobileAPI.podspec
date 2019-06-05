#
# Be sure to run `pod lib lint ClutchMobileAPI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ClutchMobileAPI'
  s.version          = '0.1.0'
  s.summary          = 'Helper for access to the Clutch mobile API from iOS applications'
  s.description      = <<-DESC
  Helper for access to the Clutch Mobile API from iOS applications, adding basic loyalty/gift functionality.
                       DESC

  s.homepage         = 'https://github.com/ClutchModules/MobileSDKiOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Clutch' => 'asksupport@clutch.com' }
  s.source           = { :git => 'https://github.com/ClutchModules/MobileSDKiOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ClutchMobileAPI/Classes/**/*'
  
  s.dependency 'AFNetworking', '~>3.0'
end
