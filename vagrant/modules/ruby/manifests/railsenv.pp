class ruby::railsenv($env = "production") {
  line { "rails-env-$env":
    file => "/etc/environment",
    line => "RAILS_ENV=\"$env\""
  }

  line { "rack-env-$env":
    file => "/etc/environment",
    line => "RACK_ENV=\"$env\""
  }

  define line($file, $line) {
    exec { "/bin/echo '${line}' >> '${file}'":
      unless => "/bin/grep -qFx '${line}' '${file}'"
    }
  }
}
