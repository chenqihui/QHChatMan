#
# Be sure to run `pod lib lint QHChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QHChatMan'
  s.version          = '1.0.0'
  s.summary          = '直播间的公屏模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
快速集成 直播间的公屏，可自定义不同的聊天样式，具体请参考 Demo。
                       DESC

  s.homepage         = 'https://github.com/chenqihui/QHChatMan'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'AnakinChen' => 'chen_qihui@qq.com' }
  s.source           = { :git => 'https://github.com/chenqihui/QHChatMan.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'src/**/*.{h,m}'
  
  # s.resource_bundles = {
  #   'QHChat' => ['QHChat/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
