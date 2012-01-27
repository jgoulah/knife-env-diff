# knife-env-diff

A plugin for Chef::Knife which will diff the cookbook versions of two or more environments.

## Usage 

Supply two or more environments to get a diff of their cookbook versions

```
% knife environment diff development production

diffing environment development against production

cookbook: hadoop
 development version: = 0.1.0
 production version: = 0.1.8

cookbook: mysql
 development version: = 0.2.4
 production version: = 0.2.5
```

## Installation

#### Script install

Copy the knife-env-diff script from lib/chef/knife/env-diff.rb to your ~/.chef/plugins/knife directory.

#### Gem install

knife-env-diff is available on rubygems.org - if you have that source in your gemrc, you can simply use:

    gem install knife-env-diff
