Pod::Spec.new do |s|
  s.name         = "LDNavigationSolution"
  s.version      = "1.0.0"
  s.summary      = "A iOS navigation solution."
  s.homepage     = "https://github.com/l1Dan/LDNavigationSolution"
  s.license      = "MIT"
  s.author       = { "Dennis Lee" => "l1dan@hotmail.com" }
  s.source       = { :git => "https://github.com/l1Dan/LDNavigationSolution.git", :tag => "#{s.version}" }
  
  s.ios.deployment_target = "7.0"
  s.source_files  = "Source/*.{h,m}"
end
