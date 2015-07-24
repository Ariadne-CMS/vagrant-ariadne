class ariadne::depends {
	$packages = [ "php-pear", "poppler-utils", "imagemagick", "php5-mysql", "php-soap", "subversion", "php5-gd", "tidy", "php5-curl", "php5-cli", "php5-xcache", "php5-mcrypt", "php5-xdebug" ]

	package { $packages:
		ensure  => present,
	}
	package { php5-tidy:
		ensure  => absent,
	}
	vcsrepo { "/usr/share/php/VersionControl":
		ensure   => present,
		provider => svn,
		source   => "https://svn.muze.nl/svn/muze/pear/VersionControl",
	}

}


