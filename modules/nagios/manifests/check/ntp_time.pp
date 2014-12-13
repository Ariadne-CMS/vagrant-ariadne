define nagios::check::ntp_time (
  $args       = '',
  $ntp_server = $::nagios_check_ntp_time_target,
) {

  # Required plugin
  if $::nagios_check_ntp_time_ensure != 'absent' {
    Package <| tag == 'nagios-plugins-ntp' |>
  }

  # Generic overrides
  if $::nagios_check_ntp_time_check_period != '' {
    Nagios_service { check_period => $::nagios_check_ntp_time_check_period }
  }
  if $::nagios_check_ntp_time_notification_period != '' {
    Nagios_service { notification_period => $::nagios_check_ntp_time_notification_period }
  }

  # Service specific overrides
  if $::nagios_check_ntp_time_warning != '' {
    $warning = $::nagios_check_ntp_time_warning
  } else {
    $warning = '1'
  }
  if $::nagios_check_ntp_time_critical != '' {
    $critical = $::nagios_check_ntp_time_critical
  } else {
    $critical = '2'
  }
  if $ntp_server != '' {
    $target = $ntp_server
  } else {
    $target = '1.rhel.pool.ntp.org'
  }

  nagios::client::nrpe_file { 'check_ntp_time':
    args => "-H ${target} -w ${warning} -c ${critical} ${args}",
  }

  nagios::service { "check_ntp_time_${title}":
    check_command       => 'check_nrpe_ntp_time',
    service_description => 'ntp_time',
    #servicegroups       => 'ntp_time',
  }

}

