Pod::Spec.new do |spec|
    spec.name                   = 'Spinner'
    spec.version                = '1.2.3'
    spec.summary                = 'Present loading indicators anywhere quickly and easily'

    spec.homepage               = 'https://github.com/nodes-ios/Serpent'
    spec.author                 = { 'Mostafa Amer' => 'mostafamamer@gmail.com' }
    spec.source                 = { :git => 'https://github.com/nodes-ios/Spinner.git', :tag => spec.version.to_s }
    spec.license                = 'MIT'

    spec.ios.deployment_target  = '8.0'
    spec.tvos.deployment_target = '9.0'

    spec.source_files           = 'Spinner/Spinner.swift'

end
