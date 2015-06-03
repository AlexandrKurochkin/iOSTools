

Pod::Spec.new do |s|

  s.name         = "iOSTools"
  s.version      = "0.0.3"
  s.summary      = "Own collection of solutions to common problems in iOS Development."
  s.homepage     = "https://github.com/AlexandrKurochkin/iOSTools"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "AlexandrKurochkin" => "kurochkin91@gmail.com" }
  s.social_media_url   = "https://ua.linkedin.com/pub/alexander-kurochkin/34/b6b/5"
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/AlexandrKurochkin/iOSTools.git", :tag => "0.0.3" }


  s.source_files  = "iOSTools/**/*.{h,m}"
  s.public_header_files = "iOSTools/**/*.h"

  s.framework  = "Foundation"
  s.requires_arc = true

end
