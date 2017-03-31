Pod::Spec.new do |s|
  s.name         = "NSLNavigationSolution"
  s.version      = "1.1.0"
  s.summary      = "A iOS navigation solution."
  s.homepage     = "https://github.com/l1Dan/NSLNavigationSolution"
  s.license      = "MIT"
  s.author       = { "Dennis Lee" => "l1dan@hotmail.com" }
  s.source       = { :git => "https://github.com/l1Dan/NSLNavigationSolution.git", :tag => "#{s.version}" }
  
  s.ios.deployment_target = "7.0"
  s.source_files  = "NSLNavigationSolution/Source/*.{h,m}"
end
