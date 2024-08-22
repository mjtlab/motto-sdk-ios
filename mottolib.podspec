#
# Be sure to run `pod lib lint mottolib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'mottolib'
  s.version          = '0.0.7'
  s.summary          = 'Motto SDK-iOS'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Motto SDK - iOS
                       DESC

  s.homepage         = 'https://motto.kr/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daybreaker48' => 'prof.dagian@gmail.com' }
  s.source           = { :git => 'https://github.com/mjtlab/motto-sdk-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'mottolib/Classes/**/*'
  
   s.resource_bundles = {
     'mottolib' => ['mottolib/Assets/*.png']
   }

   s.resources = 'mottolib/Assets/*.png'
 #
 #   s.pod_target_xcconfig = {
 #       'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
 #   }
 #
 #   s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
 #
 #   s.info_plist = {
 #       'CFBundleIdentifier' => 'org.cocoapods.mottosdkios'
 #   }
   
 #  s.info_plist = {
 #    'GADApplicationIdentifier' => 'ca-app-pub-7193526914088525~8955940728'
 #  }

   # s.public_header_files = 'Pod/Classes/**/*.h'
   # s.static_framework = true
   # s.vendored_frameworks = "mottolib.xcframework"
   
   s.frameworks = 'UIKit', 'WebKit', 'Foundation', 'CFNetwork'
   s.dependency 'SnapKit', '~> 5.6.0'
   s.dependency 'Then'
   s.dependency 'Alamofire'
 #  s.dependency 'Google-Mobile-Ads-SDK', '<= 11.5.0'
   s.dependency 'VungleAds'
   s.dependency 'UnityAds'
end
