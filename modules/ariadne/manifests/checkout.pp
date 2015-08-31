class ariadne::checkout {

	file { "/opt/ariadne":
		ensure => "directory",
		owner => "vagrant",
		group => "vagrant",
		mode => 755
	}

	package { 'git':
		ensure => present
	}
	package { 'lynx':
		ensure => present
	}

	vcsrepo { "/opt/ariadne/ariadne":
		ensure   => present,
		provider => git,
		source   => "https://github.com/Ariadne-CMS/ariadne/",
		require => [ File['/opt/ariadne/'], Package['git'] ],
		before => File['/opt/ariadne/apache/ariadne'],
		owner => "vagrant",
		group => "vagrant",
		notify => Exec['symlinker']
	}

	$localfiles = [
		"/opt/ariadne/site/",
		"/opt/ariadne/site/lib/",
		"/opt/ariadne/site/lib/configs/",
		"/opt/ariadne/apache/",
		"/opt/ariadne/local",
		"/opt/ariadne/local/www",
		"/opt/ariadne/local/lib",
		"/opt/ariadne/local/lib/configs",
	]

	file { $localfiles:
		ensure => "directory",
		owner => "vagrant",
		group => "vagrant",
		mode => 755
	}

	file { "/opt/ariadne/site/files":
		ensure => "symlink",
		target => "/opt/ariadne/files",
	}

	file { "/opt/ariadne/apache/ariadne":
		ensure => "symlink",
		target => "/opt/ariadne/site/www",
		require => Exec['symlinker']
	}

	$files = [ 
		"/opt/ariadne/files",
		"/opt/ariadne/files/files",
		"/opt/ariadne/files/templates",
		"/opt/ariadne/files/temp",
		"/opt/ariadne/site/lib/configs/svn/",
	]

	file { $files:
		ensure => "directory",
		owner => "www-data",
		group => "www-data",
		mode => 775
	}

	file { '/opt/ariadne/local/www/ariadne.inc':
		content => "<?php \$ariadne='/opt/ariadne/site/lib'; ?>",
		ensure => "present",
		mode => 644,
	}
	file { '/opt/ariadne/local/lib/configs/ariadne.phtml':
		replace => "no",
		content => "",
		ensure => "present",
		mode => 644,
		owner => "www-data",
		group => "www-data",
		notify => Exec['installer']
	}

	exec { 'symlinker':
		cwd => '/opt/ariadne/ariadne/bin',
		command => '/usr/bin/php ./createsymlinks.php',
		refreshonly => true,
		require => [ 
			File['/opt/ariadne/local/lib/configs/ariadne.phtml'],
			File['/opt/ariadne/local/www/ariadne.inc'],
		],
		user => "vagrant",
		group => "vagrant",
	}

	exec { 'installer':
		command => 'echo "language=en&step=step6&database=mysql&database_host=localhost&database_user=ariadne&database_pass=ariadne&database_name=ariadne&admin_pass=ariadne&admin_pass_repeat=ariadne&ariadne_location&enable_svn=1&install_demo=1" | lynx -post_data http://localhost/ariadne/install/index.php',
		path => '/bin/:/usr/bin/',
		unless      => "/usr/bin/test -s /opt/ariadne/local/lib/configs/ariadne.phtml",
		require => [ 
			File['/opt/ariadne/local/lib/configs/ariadne.phtml'],
			File['/opt/ariadne/local/www/ariadne.inc'],
			Package['lynx'],
		]
	}

	File['/opt/ariadne/site/files'] -> Exec['symlinker']
	Exec['symlinker'] -> Exec['installer']
	File<| |> -> Exec['installer']
}
