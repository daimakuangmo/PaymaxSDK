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
  s.homepage     = 'hhttps://github.com/daimakuangmo/WXQPod'
  s.license      = 'MIT'
  s.platform     = :ios
  s.author       = {'wangxiaoqiang' => 'codeingwang@163.com'}

  s.ios.deployment_target = '11.0'
  s.source       = {:git => 'https://github.com/daimakuangmo/WXQPod.git', :tag => s.version}
  s.source_files = 'WXQPodSDK/*.{h,m}'
  s.resources    = 'WXQPodSDK/*.{png,xib,nib,bundle}'
  s.vendored_libraries = 'WXQPodSDK/*.a'
  s.requires_arc = true

end
