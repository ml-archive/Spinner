Pod::Spec.new do |spec|
    spec.name                   = 'NSpinner'
    spec.version                = '1.2.4'
    spec.summary                = 'Present loading indicators anywhere quickly and easily'

    spec.homepage               = 'https://github.com/nodes-ios/Spinner'
    spec.author                 = { "Nodes Agency - iOS" => "ios@nodes.dk" }
    spec.source                 = { :git => 'https://github.com/nodes-ios/Spinner.git', :tag => spec.version.to_s }
    spec.license                = 'MIT'

    spec.ios.deployment_target  = '9.0'
    spec.tvos.deployment_target = '9.0'

    spec.source_files           = 'Spinner/Spinner.swift'

end
