Pod::Spec.new do |s|
  s.name         = 'PaymaxSDK'
  s.version      = '1.0.1'
  s.summary      = 'PaymaxSDK task '
  s.description  = <<-DESC
                      lkl-boss-sdk
                   DESC
  s.homepage     = 'https://github.com/daimakuangmo/PaymaxSDK'
  s.license      = 'MIT'
  s.platform     = :ios
  s.author       = {'wangxiaoqiang' => 'codeingwang@163.com'}

  s.ios.deployment_target = '8.1'
  s.source       = {:git => 'https://github.com/daimakuangmo/PaymaxSDK.git', :tag => s.version}
  s.requires_arc = true
  s.default_subspec = 'Paymax'
  # s.dependency 'WechatOpenSDK'


  s.subspec 'Paymax' do |paymax|
    paymax.source_files = 'PaymaxSDK/*.h'
    paymax.public_header_files = 'PaymaxSDK/*.h'
    paymax.vendored_libraries = 'PaymaxSDK/*.a'
    paymax.frameworks = 'CFNetwork', 'SystemConfiguration', 'Security', 'CoreLocation','CoreMotion', 'CoreTelephony'
    paymax.ios.library = 'c++', 'stdc++' , 'z'
    paymax.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end

  # s.subspec 'Alipay' do|alipay|
  #   alipay.vendored_libraries = 'PaymaxSDK/Paymax+alipay/*.a'
  #   alipay.ios.vendored_frameworks = 'PaymaxSDK/Paymax+alipay/Alipay/AlipaySDK.framework'
  #   alipay.resource = 'PaymaxSDK/Paymax+alipay/Alipay/AlipaySDK.bundle'
  #   alipay.dependency 'PaymaxSDK/Paymax'
  # end

  # s.subspec 'LKL' do|lkl|
  #   lkl.source_files = 'PaymaxSDK/Paymax+lkl/lkl/*.h'
  #   lkl.vendored_libraries = 'PaymaxSDK/Paymax+lkl/*.a' 
  #   lkl.vendored_libraries = 'PaymaxSDK/Paymax+lkl/lkl/*.a'
  #   lkl.resource = 'PaymaxSDK/Paymax+lkl/lkl/LKLImages.bundle'
  #   lkl.dependency 'PaymaxSDK/Paymax'
  # end


end
