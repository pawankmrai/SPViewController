Pod::Spec.new do |spec|

  spec.name           = "SPViewController"
  spec.version        = "1.0.0"
  spec.summary        = "Searchable Picker View Controller"
  spec.description    = "Searchable picker view controller created as part of VDB app development support"
  spec.homepage       = "https://github.com/pawankmrai/SPViewController"
  spec.license        = "MIT"
  spec.author         = { "Pawan Rai" => "ghz.rai@gmail.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://github.com/pawankmrai/SPViewController.git", :tag => "1.0.0" }
  spec.swift_version  = "4.2"
  spec.version        = "1.0.0"
  spec.source_files   = "SPViewController"
  spec.exclude_files  = "Classes/Exclude"
end
