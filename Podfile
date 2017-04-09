platform :ios, '10.0'
use_frameworks!

target 'doGRT' do
  pod 'FMDB', '~> 2.4'
  pod 'QuickDialog', '~> 1.0'
  pod 'InformaticToolbar', '~> 0.2.1'
  pod 'REMenu', '~> 1.10'
  pod 'AFNetworking', '~> 3.0'
  pod 'FMDBMigrationManager', '~> 1.4'
  pod 'CSVImporter', '~> 1.7'
  pod 'SSZipArchive', '~>1.7'
  pod 'NSLogger'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
