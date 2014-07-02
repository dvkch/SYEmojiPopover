Pod::Spec.new do |s|
  s.name     = 'SYEmojiPopover'
  s.version  = '0.1'
  s.license  = ''
  s.summary  = 'Popover view to select emoji character from iOS 5+ possible characters. iOS 5+, ARC.'
  s.homepage = 'https://github.com/dvkch/SYEmojiPopover'
  s.author   = { 'Stan Chevallier' => 'contact@stanislaschevallier.fr' }
  s.source   = { :git => 'https://github.com/dvkch/SYEmojiPopover.git' }
  s.source_files = 'SYEmojiPopover/*.{h,m}'
  s.requires_arc = true

  s.dependency 'PopoverView'

  s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES' }
  s.ios.deployment_target = '5.0'
  
end
