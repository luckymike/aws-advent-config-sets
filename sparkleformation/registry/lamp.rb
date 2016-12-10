## Installs a LAMP stack on Ubuntu. Optionally allows swapping webserver or database (NGINX/PostgreSQL) or omitting one or more packages. Technically, you could use this to install any package.
## Args: A hash with package names as keys, and true/false/version as values, e.g.:
## registry!(:lamp, { apache2: true, php5: '5.6', postgresql: false })
## Without arguments, defaults to Apache, MySQL, PHP, with latest versions.

SfnRegistry.register(:lamp) do |args = {}|
  pkgs = {'apache2' => true, 'mysql-server' => true, 'php5' => true }.merge(args)
  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    configSets do |sets|
      sets.default += [ 'lamp' ]
    end
    lamp do
      packages do
        apt do
          pkgs.each do |pkg, ver|
            set!(pkg, ver == true ? '' : ver) if ver
          end
        end
      end
    end
  end
end
