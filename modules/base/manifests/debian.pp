class base::debian {
    class{ 'apt':
        purge => {
            'sources.list'   => true,
            'sources.list.d' => true,
        }
    }

    include ::apt
    include ::apt::update

    apt::source { 'debian':
        location => 'http://ftp.nl.debian.org/debian/',
        repos    => 'main contrib non-free',
        key      => {
            id     => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
            server => 'pool.sks-keyservers.net',
        },
    }

    apt::source { 'puppetlabs':
        location => 'http://apt.puppetlabs.com',
        repos    => 'main',
        key      => {
            id     => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
            server => 'pool.sks-keyservers.net',
        },
    }

    user { 'vagrant':
        ensure => present,
        shell  => '/bin/bash',
    }

    package { 'vim':
        ensure => present,
    }

    Class['apt::update'] -> Package <| |>
}

