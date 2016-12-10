## Downloads and unpacks wordpress.
## Optionally specify the install directory and Wordpress version. e.g.:
## registry!(:wordpress, directory: '/opt/wordpress', version: '4.6')
## Without args, installs latest version to '/var/www'
## Note: directory cannot be set with a parameter, because the actual value is needed to set the source.

SfnRegistry.register(:wordpress) do |args = {}|
  install_dir = args.fetch(:directory, '/var/www')
  wp_file = args[:version].nil? ? 'latest' : join!('wordpress-', args[:version])
  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    configSets do |sets|
      sets.default += ['wordpress']
    end
    wordpress do
      sources do
        set!(install_dir, join!(
          'https://wordpress.org/',
          wp_file,
          '.tar.gz'
        ))
      end
      commands do
        mv_files_up do
          command 'mv wordpress/* ./'
          cwd install_dir
        end
        rm_wp_dir do
          command 'rm -r wordpress'
          cwd install_dir
        end
      end
    end
  end
end
