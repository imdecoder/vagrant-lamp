Vagrant LAMP
==========

My LAMP development stack configuration for Vagrant, inspired by Vaprobash

Dependencies
---------------------
* [VirtualBox](http://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com)

Installation
---------------
Download a vagrant box (I am using ubuntu/trusty64)
`$ vagrant box add ubuntu/trusty64`
    
Clone this repository
`$ git clone https://github.com/imdecoder/vagrant-lamp.git`

Go to the repository folder and launch the box
```
$ cd [repo]
$ vagrant up
```

Installed
------------
* Apache
* PHP
* MySQL
* xdebug
* git
* Composer

Notes
--------
### MySQL
Using SSH Tunel to connect from you local like Vaprobash
username=root
password=root
ssh username=vagrant
ssh password=vagrant
ssh port=2222

TODO
---------
remote call shell scripts like Vaprobash