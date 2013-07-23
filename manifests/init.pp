# Public: Install and configure git from homebrew.
#
# Examples
#
#   include git
class git {
  include homebrew
  include git::config

  package { 'git':
    ensure   => $git::config::version,
    provider => homebrew
  }

  file { $git::config::configdir:
    ensure => directory
  }

  file { $git::config::credentialhelper:
    ensure => file
  }

  file { $git::config::global_credentialhelper:
    ensure  => link,
    target  => $git::config::credentialhelper,
    before  => Package['git'],
    require => File[$git::config::credentialhelper]
  }

  file { "${git::config::configdir}/gitignore":
    source  => 'puppet:///modules/git/gitignore',
    require => File[$git::config::configdir]
  }

  git::config::global{ 'credential.helper':
    value => $git::config::global_credentialhelper
  }

  git::config::global{ 'core.excludesfile':
    value   => "${git::config::configdir}/gitignore",
    require => File["${git::config::configdir}/gitignore"]
  }

  if $::gname {
    git::config::global{ 'user.name':
      value => $::gname
    }
  }

  if $::gemail {
    git::config::global{ 'user.email':
      value => $::gemail
    }
  }
}
