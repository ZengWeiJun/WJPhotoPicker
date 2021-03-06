
Pod::Spec.new do |s|
  s.name         = "WJPhotoPicker"
  s.version      = "1.1.9"
  s.summary      = "A simple and easy to use photo picker."

  s.author       = { "zwj" => "niuszeng@sina.com" }
  s.homepage     = "https://github.com/ZengWeiJun/WJPhotoPicker"
  s.license      = "MIT"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ZengWeiJun/WJPhotoPicker.git", :tag => s.version }
  s.source_files  = "WJPhotoPicker", "WJPhotoPicker/*.{h,m}"
  s.resources = "WJPhotoPicker/Images/*.png"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency "MBProgressHUD", '~> 0.9.2'
end
