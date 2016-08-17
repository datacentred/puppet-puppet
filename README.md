#Puppet

[![Build Status](https://travis-ci.org/spjmurray/puppet-puppet.png?branch=master)](https://travis-ci.org/spjmurray/puppet-puppet)

####Table Of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage](#usage)
4. [Dependencies](#dependencies)
5. [Contribution](#contribution)

##Overview

Deploys and configures Puppet

##Module Description

Lightweight puppet deployment.  Performs only the most rudimentary installation
tasks, configuration is up to the user.  Configuration is performed entriely in
hiera to cleanly separate code from data.  Puppet defaults are typically
sufficient to create a working setup.

##Usage

```puppet
include ::puppet
include ::puppet::server
```

```yaml
---
puppet::repo_manage: true

puppet::hiera: |
  :backends:
    - yaml
  :yaml:
    :datadir: "/etc/puppet/environments/%%{}{::environment}/hiera"
  :hierarchy:
    - "nodes/%%{}{::hostname}"
    - "modules/%%{}{calling_module}"
    - common

puppet::conf:
  master:
    environmentpath: '$confdir/environments'
```

Please note the escape sequences in the puppet::hiera string as at present
with foss hiera it will try interpolate %{} statements unconditionally

##Dependencies

- http://github.com/puppetlabs/puppetlabs-apt
- http://github.com/puppetlabs/puppetlabs-stdlib

If you are using the HAProxy load balancer class you will need

- http://github.com/puppetlabs/puppetlabs-concat
- http://github.com/puppetlabs/puppetlabs-haproxy

##Contribution

I'm keen to keep this module lightweight and maintainable.  As such, much is hard
coded to Ubuntu, however most pertinent options can be controlled via parameters.
Likewise there are no configuration related hacks, all configuration is passed in
pretty much verbatim via parameters, so should never be changed.

That said if extensions are required ensure the changes are unit tested before
submission.  Please at least run:

```
rake lint
rake validate
rake beaker
```

