SparkleFormation.component(:compute) do
  set!('AWSTemplateFormatVersion', '2010-09-09')

  registry!(:official_amis, :advent, :type => 'ebs')

  parameters do
    stack_creator do
      type 'String'
      default ENV['USER']
    end

    vpc_id do
      type 'String'
      description 'VPC to Join'
    end

    availability_zone do
      type 'String'
      description 'Availability Zone for Subnet'
      default registry!(:zones).first
    end

    public_subnet_id do
      type 'String'
      description 'Public Subnet ID'
    end
  end

  ## Creates IAM role that can access compute resource metadata.
  resources do

    cfn_role do
      type 'AWS::IAM::Role'
      properties do
        assume_role_policy_document do
          version '2012-10-17'
          statement array!(
            -> {
              effect 'Allow'
              principal do
                service ['ec2.amazonaws.com']
              end
              action ['sts:AssumeRole']
            }
          )
        end
        path '/'
        policies array!(
          -> {
            policy_name 'cfn_access'
            policy_document do
              statement array!(
                -> {
                  effect 'Allow'
                  action 'cloudformation:DescribeStackResource'
                  resource '*'
                }
              )
            end
          }
        )
      end
    end

    advent_instance_profile do
      type 'AWS::IAM::InstanceProfile'
      properties do
        path '/'
        roles [ ref!(:cfn_role) ]
      end
    end

    advent_security_group do
      type 'AWS::EC2::SecurityGroup'
      properties do
        group_description "Security Group for Advent"
        vpc_id ref!(:vpc_id)
      end
    end

    advent_security_group_ingress do
      type 'AWS::EC2::SecurityGroupIngress'
      properties do
        group_id ref!(:advent_security_group)
        ip_protocol '-1'
        from_port 1
        to_port 65535
        cidr_ip '0.0.0.0/0'
      end
    end

    advent_security_group_egress do
      type 'AWS::EC2::SecurityGroupEgress'
      properties do
        group_id ref!(:advent_security_group)
        ip_protocol '-1'
        from_port 1
        to_port 65535
        cidr_ip '0.0.0.0/0'
      end
    end

    advent_ec2_instance do
      type 'AWS::EC2::Instance'
      properties do
        iam_instance_profile ref!(:advent_instance_profile)
        image_id  map!(:official_amis, region!, 'trusty')
        instance_type 't2.micro'
        network_interfaces array!(
          -> {
            associate_public_ip_address true
            device_index 0
            subnet_id ref!(:public_subnet_id)
            group_set [ ref!(:advent_security_group) ]
          }
        )
      end
      creation_policy do
        resource_signal do
          count 1
          timeout 'PT15M'
        end
      end
    end
  end

  outputs do
    hostname do
      value attr!(:advent_ec2_instance, :public_dns_name)
    end
    address do
      value attr!(:advent_ec2_instance, :public_ip)
    end
  end
end
