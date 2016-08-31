Pod::Spec.new do |s|
  s.name         = "STPopupPreview"
  s.version      = "1.0.1"
  s.summary      = "An alternative peek preview for non 3D Touch devices. Inspired by Instagram."

  s.description  = <<-DESC
                    - STPopupPreview uses long press gesture to enable quick preview of a page on non 3D Touch devices. Preview actions are also supported. This idea is inspired by Instagram.
                    - It is built on top of of STPopup(a library provides STPopupController, which works just like UINavigationController in popup style). Both STPopup and STPopupPreview support iOS 7+.
                    DESC

  s.homepage     = "https://github.com/kevin0571/STPopupPreview"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Kevin Lin" => "kevin_lyn@outlook.com" }

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/kevin0571/STPopupPreview.git", :tag => s.version }

  s.source_files = "STPopupPreview/*.{h,m}"
  s.public_header_files = "STPopupPreview/*.h"
  s.dependency 'STPopup', '~> 1.7'
end
