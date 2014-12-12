class base::wheezy {
	class{ 'apt':
		purge_sources_list   => true,
		purge_sources_list_d   => true,
	}

	include apt

	class { 'apt::release':
		release_id => 'wheezy',
	}
	apt::source { 'debian':
		location          => 'http://ftp.nl.debian.org/debian/',
		repos             => 'main contrib non-free',
		key               => '46925553',
		key_server        => 'subkeys.pgp.net',
		include_src       => false,
	}

	apt::source { 'puppetlabs':
		location   => 'http://apt.puppetlabs.com',
		  repos      => 'main',
		  key        => '4BD6EC30',
		  key_server => 'pgp.mit.edu',
		  include_src       => false,
	}

	user { "vagrant":
		ensure => present,
		shell  => "/bin/bash",
	}

	package { "vim":
		ensure  => present,
	}

	Class['apt'] -> Package <| |>
}

