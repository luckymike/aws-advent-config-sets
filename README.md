# aws-advent-config-sets
default Configset examples to accompany my [AWS Advent 2016 article](https://www.awsadvent.com/2016/12/13/modular-cfn-init-configsets-with-sparkleformation/).

This repo is not intended to demonstrate general SparkleFormation patterns. I've taken shortcuts to focus on the registry entries. For a more complete SparkleFormation primer, checkout [the Workshop repo](https://github.com/reverseskate/sparkleformation-workshops) and, of course, [read the docs](http://www.sparkleformation.io/docs/).

## Setup
export the following environment variables to use this repo:
```sh
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
```

## Template
This repo contains a single template (`template.rb`) that demonstrates the default behavior of the included registry entries on an Ubuntu 14.04 instance. Feel free to manipulate it as needed to experiment, or copy the registry entries into your project and use them with your own compute templates.

This template requires a public subnet. Please note that all ports are open to the world. This is not meant for production use. It is just an example. :)

## Registry Entries
This repo has 3 registry entries to demonstrate default Configset usage:
* `github_ssh_user` - Retrieves a Github user's public keys and adds them to the `ubuntu` or `ec2-user`, depending on the platform.
* `lamp` - Installs packages for a LAMP stack on Ubuntu (Linux, Apache, MySQL, PHP). Also accepts config to allow installing other packages.

* `wordpress` - Downloads and unpacks [Wordpress](https://wordpress.org/).

## Questions
Feel free to ask questions about the pattern via the Issues. If you encounter an error, please let me know. If you have other relevant Configset examples, PRs are welcome.
