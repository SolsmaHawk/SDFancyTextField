#
# Be sure to run `pod lib lint SDFancyTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SDFancyTextField'
  s.version          = '0.1.0'
  s.summary          = 'A fancy, animated, interface builder-compatible, text field with automated validation built-in'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SDFancyTextField is a UIView subclass that replicates the functionality of a UITextField with many added features including automated field-validation and unique animations. UITextField has always been a little… plain. With SDFancyTextField you can easily add an interactive textfield in code or using interface builder. Using interface builder, an SDFancyTextField can be placed in your view and entirely customized within IB. In only a couple lines of code you can have the textfield setup to automatically validate and organize textfields into forms that can be validated all at once (all with fancy animations 😎).
                       DESC

  s.homepage         = 'https://github.com/SolsmaHawk/SDFancyTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SolsmaHawk' => 'solsma@me.com' }
  s.source           = { :git => 'https://github.com/SolsmaHawk/SDFancyTextField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.1'
  s.source_files = 'SDFancyTextField/*.{h,m,swift}'
  
  # s.resource_bundles = {
  #   'SDFancyTextField' => ['SDFancyTextField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
