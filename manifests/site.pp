node ariadne-dev {
	include base::debian
	include mysql::server
	include ariadne::depends

	class { 'apache':
		mpm_module          => 'prefork',
		server_signature    => 'Off',
		server_tokens       => 'Prod',
		trace_enable        => 'Off',
		default_vhost => false,
	}

	include apache::mod::php


	mysql::db { 'ariadne':
		user     => 'ariadne',
		password => 'ariadne',
		host     => 'localhost',
		grant    => ['ALL'],
	}


		apache::vhost { "default-localhost":
			port => 80,
			docroot  => '/opt/ariadne/apache/',
			priority => '01',
		}
	include ariadne::checkout

	Class['apache'] -> Class['ariadne::checkout']



}
