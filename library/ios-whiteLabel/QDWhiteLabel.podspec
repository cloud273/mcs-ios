Pod::Spec.new do |s|

  s.name         = "QDWhiteLabel"

  s.version      = "1.0.0"

  s.summary      = "QDWhiteLabel framework"

  s.description  = "This framework is designed for white label app"

  s.homepage     = "http://cloud273.com"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "DUNG NGUYEN"

  s.platform     = :ios, "12.0"

  s.source       = { :path => 'source' }

  s.swift_versions = ['5.0', '5.1']

  s.source_files = "source/*.swift"

  s.framework    = "UIKit"

end
