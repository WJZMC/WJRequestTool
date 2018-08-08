#
# Be sure to run `pod lib lint WJRequestTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WJRequestTool'
  s.version          = '1.0.5'
  s.summary          = '基于AFNetworking的封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
请求的封装，包含加密、错误处理、逻辑解耦、业务拆分、数据解析等
                       DESC

  s.homepage         = 'https://github.com/WJZMC/WJRequestTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jack' => 'jack_weijie@foxmail.com' }
  s.source           = { :git => 'https://github.com/WJZMC/WJRequestTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WJRequestTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WJRequestTool' => ['WJRequestTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.frameworks = 'UIKit'
  s.dependency 'AFNetworking'
  s.dependency 'PPNetworkHelper'
  s.dependency 'SVProgressHUD'
  s.dependency 'YYModel'
  s.dependency 'YYCache'
end
