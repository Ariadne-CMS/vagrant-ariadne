class ariadne::vcs {
	package { 'git':
		ensure => present
	}
	vcsrepo { "/opt/ariadne/ariadne":
		ensure   => present,
		provider => git,
		source   => "https://github.com/Ariadne-CMS/ariadne/",
		require => File['/opt/ariadne/']
	}
}
