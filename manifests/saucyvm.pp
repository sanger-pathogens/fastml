package { "dh-make":
    ensure => "installed"
    }

package { ["gcc", "build-essential", "pkg-config"]:
    ensure => "installed"
    }

package {"language-pack-en":
    ensure => "installed"
    }
