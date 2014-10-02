class beaker::setup {
   yumrepo { 'base':
   	enabled => 0,
   	require => Yumrepo['puppet'],
   }
   yumrepo { 'puppet':
   	enabled => 0,
   }
   yumrepo { "scl_ruby193":
      baseurl => "https://www.softwarecollections.org/repos/rhscl/ruby193/epel-6-x86_64/",
      descr => "Ruby 1.9.3 Dynamic Software Collection",
      enabled => 1,
      gpgcheck => 0,
   }
   yumrepo { "v8314_epel":
      baseurl => "https://www.softwarecollections.org/repos/rhscl/v8314/epel-6-x86_64/",
      descr => "v8314 epel-6-x86_64",
      enabled => 1,
      gpgcheck => 0,
      require => Yumrepo['scl_ruby193'],
   }
   yumrepo { "rhscl_v8314_epel":
      baseurl => "https://www.softwarecollections.org/repos/rhscl/v8314/rhscl-v8314-epel-6-x86_64/",
      descr => "rhscl-v8314-epel-6-x86_64",
      enabled => 1,
      gpgcheck => 0,
      require => [ Yumrepo['scl_ruby193'], Yumrepo['v8314_epel'] ],
   }
   yumrepo { "oel_public":
      baseurl => "http://public-yum.oracle.com/repo/OracleLinux/OL6/5/base/x86_64/",
      descr => "OEL 6.5 x86_64 Public Yum Repo",
      enabled => 1,
      gpgcheck => 0,
   }
   package { 'epel-release':
	  ensure => installed,
   	  source => "https://anorien.csc.warwick.ac.uk/mirrors/epel/6/x86_64/epel-release-6-8.noarch.rpm",
   	  provider => rpm,
   	  require => [ Yumrepo['rhscl_v8314_epel'], Yumrepo['oel_public'], Yumrepo['base'] ],
   }   
   package { 'puppetlabs-release':
   	  ensure => installed,
   	  source => "https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm",
   	  provider => rpm,
   	  require => Package['epel-release'],
   }	
     
   $packages = [ 'ruby-devel', 'libxml2-devel', 'libxslt-devel', 'gcc-c++', 'libicu-devel']
   $beaker_path = '/tmp/beaker'
   
   package { $packages:
   	  ensure => installed,
   	  require => Package['puppetlabs-release'],
   } ->
   vcsrepo { $beaker_path:
	  ensure   => present,
  	  provider => git,
  	  source => "https://github.com/puppetlabs/beaker.git",  	  
   }   
   exec { 'bundle_install_beaker':
   	  cwd => "$beaker_path",
   	  command => '/usr/bin/bundle install > .bundle.log',
   	  creates => "$beaker_path/.bundle.log",
   	  require => Vcsrepo["$beaker_path"],
   	}   	  
}