# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GameCatalog' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for GameCatalog
    pod "SnapKit"
    pod "RxCocoa"
    pod "RxSwift"
    pod "Kingfisher"
    pod "Moya"
    pod "RangeSeekSlider"
    
    target 'GameCatalogTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'GameCatalogUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ["Kingfisher", "RxSwift", "RxCocoa", "Moya", "SnapKit"].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end

        if ["RangeSeekSlider", "CouchbaseLite-Swift"].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
