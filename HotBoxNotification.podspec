Pod::Spec.new do |s|
  s.name         = "HotBoxNotification"
  s.version      = "1.1.0"
  s.summary      = "Unobtrusive and customizable alerts for your iOS app"
  s.homepage     = "https://github.com/nspassov/HotBoxNotification"
  s.license      = { :type => "MIT", :text => "Copyright (c) 2015 nspassov"}
  s.author       = { "Nikolay Spassov" => "https://spassov.me/" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/nspassov/HotBoxNotification", :tag => "master" }
  s.requires_arc = true
  s.source_files =  "HotBoxNotification/HotBoxNotification/*.{swift,h,m}"
  s.dependency 'Masonry', '~> 0.6'
end
