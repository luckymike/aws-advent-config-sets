SparkleFormation.new(:template).load(:compute).overrides do

  registry!(:official_amis, :advent, :type => 'ebs')

  parameters do
    github_user do
      type 'String'
    end

    ## These parameters can be used to set versions for
    ## packages in the :lamp registry entry.

    # apache_version do
    #   type 'String'
    # end

    # nginx_version do
    #   type 'String'
    # end

    # mysql_version do
    #   type 'String'
    # end

    # postgres_version do
    #   type 'String'
    # end

    # php_version do
    #   type 'String'
    # end

    ## Use to set a wordpress version.

    # wordpress_version do
    #   type 'String'
    # end
  end

  resources(:advent_ec2_instance) do
    type 'AWS::EC2::Instance'
    properties do
      user_data(
        base64!(
          join!(
            "#!/bin/bash\n",
            "apt-get update\n",
            "apt-get -y install python-setuptools\n",
            "easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz\n",
            '/usr/local/bin/cfn-init -v --region ',
            region!,
            ' -s ',
            stack_name!,
            ' -r ',
            process_key!(:advent_ec2_instance),
            ' --role ',
            ref!(:cfn_role),
            "\n",
            "cfn-signal -e $? --region ",
            region!,
            ' --stack ',
            stack_name!,
            ' --resource ',
            process_key!(:advent_ec2_instance),
            "\n"
          )
        )
      )
    end
    metadata('AWS::CloudFormation::Init') do
      _camel_keys_set(:auto_disable)
      configSets do
        default [ ]
      end
    end
    registry!(:github_ssh_user)
    registry!(:lamp)
    registry!(:wordpress)
  end
end
