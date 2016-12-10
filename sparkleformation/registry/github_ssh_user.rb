## Retrieves a user's public key from Github and adds it to the authorized_keys of the default user (ubuntu or ec2-user).
## Defaults to using the parameter GithubUser (ref!(:github_user)). Optionally pass an argument to set the Github user's name or
## specify another parameter:
## registry!(:github_ssh_user, username: 'github-user')
## registry!(:github_ssh_user, username: ref!(:another_parameter))


SfnRegistry.register(:github_ssh_user) do |args = {}|
  github_user = args.fetch(:username, ref!(:github_user))

  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    configSets do |sets|
      sets.default += ['github_ssh_user']
    end
    github_ssh_user do
      commands('set_ssh_keys_ubuntu') do
        command join!(
          'sudo mkdir -p /home/ubuntu/.ssh && sudo curl https://github.com/',
          github_user,
          '.keys >> /home/ubuntu/.ssh/authorized_keys'
        )
        test 'test -d /home/ubuntu'
      end
      commands('set_ssh_keys_ec2_user') do
        command join!(
          'sudo mkdir -p /home/ec2-user/.ssh && sudo curl https://github.com/',
          github_user,
          '.keys >> /home/ec2-user/.ssh/authorized_keys'
        )
        test 'test -d /home/ec2-user'
      end
    end
  end
end
