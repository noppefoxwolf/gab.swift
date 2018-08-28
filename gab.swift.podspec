Pod::Spec.new do |s|
  s.name             = 'gab.swift'
  s.version          = '0.1.0'
  s.summary          = 'Unofficial wrapper for gab.ai api, uses email & password for login'
  s.description      = <<-DESC
Unofficial wrapper for gab.ai api, uses email & password for login
                       DESC
  s.homepage         = 'https://github.com/noppefoxwolf/gab.swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'noppefoxwolf' => 'noppelabs@gmail.com' }
  s.source           = { :git => 'https://github.com/noppefoxwolf/gab.swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/noppefoxwolf'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Gab/Classes/**/*'
end
