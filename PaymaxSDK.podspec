Pod::Spec.new do |s|
  s.name         = 'PaymaxSDK'
  s.version      = '1.0.0'
  s.summary      = 'PaymaxSDK task '
  s.description  = <<-DESC
                   lkl-boss-sdk
                   lkl-boss-sdk
                   lkl-boss-sdk
                   lkl-boss-sdk
                   DESC
  s.homepage     = 'https://github.com/daimakuangmo/PaymaxSDK'
  s.license      = 'MIT'
  s.platform     = :ios
  s.author       = {'wangxiaoqiang' => 'codeingwang@163.com'}

  s.ios.deployment_target = '8.1'
  s.source       = {:git => 'https://github.com/daimakuangmo/PaymaxSDK.git', :tag => s.version}
  s.requires_arc = true
  s.default_subspec = 'Paymax', 'Alipay' , 'WX' , 'LKL'

  s.subspec 'Paymax' do |paymax|
    paymax.source_files = 'PaymaxSDK/*.{h,m}'
    paymax.public_header_files = 'PaymaxSDK/*.h'
    paymax.vendored_libraries = 'PaymaxSDK/*.a'
    paymax.frameworks = 'CFNetwork', 'SystemConfiguration', 'Security', 'CoreLocation'
    paymax.ios.library = 'c++', 'stdc++' , 'z'
    paymax.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
  end

  s.subspec 'Alipay' do|alipay|
    alipay.source_files = 'PaymaxSDK/Paymax+alipay/Alipay/*.{h,m}'
    alipay.vendored_libraries = 'PaymaxSDK/Paymax+alipay/*.a'
    alipay.ios.vendored_frameworks = 'PaymaxSDK/Paymax+alipay/Alipay/*.framework'
    alipay.resource = 'PaymaxSDK/Paymax+alipay/Alipay/*.bundle'
    alipay.frameworks = 'CoreMotion', 'CoreTelephony'
    alipay.dependency 'Paymaxpod1/Paymax'
  end

  s.subspec 'WX' do|wx|
    wx.source_files = 'PaymaxSDK/Paymax+wx/WX/*.{h,m}'
    wx.vendored_libraries = 'PaymaxSDK/Paymax+wx/*.a' , 'PaymaxSDK/Paymax+wx/WX/*.a'
    wx.dependency 'Paymaxpod1/Paymax'
  end

  s.subspec 'LKL' do|lkl|
    lkl.source_files = 'PaymaxSDK/Paymax+lkl/lkl/*.{h,m}'
    lkl.vendored_libraries = 'PaymaxSDK/Paymax+lkl/*.a' , 'PaymaxSDK/Paymax+lkl/lkl/*.a'
    lkl.resource = 'PaymaxSDK/Paymax+lkl/lkl/*.bundle'
    lkl.dependency 'Paymaxpod1/Paymax'
  end


end
