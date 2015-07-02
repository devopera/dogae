class dogae (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',

  $download_root = 'https://storage.googleapis.com/appengine-sdks/featured/',
  $download_leaf = 'google_appengine',
  $download_vbridge = '_',
  $download_ext = '.zip',
  # $command_expand = 'tar -xzvf',
  $command_expand = 'unzip',
  # $version = '1.9.23' or undef to guess latest,
  $version = undef,

  # place to locate the SDK folder
  $target_dir = undef,

  # end of class arguments
  # ----------------------
  # begin class

) {

  # if target_dir is unset, derive from user
  $real_target_dir = $target_dir ? {
    undef   => "/home/${user}",
    default => $target_dir,
  }

  # if version is undefined use our custom fact to find it
  $real_version = $version ? {
    undef   => $::dogae_appengine_version,
    default => $version,
  }

  # fetch archive from Google
  $source = "${download_root}${download_leaf}${download_vbridge}${real_version}${download_ext}"
  $destination = "${real_target_dir}/${download_leaf}${download_vbridge}${real_version}${download_ext}"
  exec { 'dogae_fetch_sdk':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    command => "wget -O ${destination} ${source} && ${command_expand} ${destination}",
    cwd     => $real_target_dir,
    user    => $user,
    creates => "${real_target_dir}/${download_leaf}",
  }->
  # delete downloaded archive and mysterious .wgetrc
  exec { 'dogae_cleanup':
    path    => '/bin/:/usr/bin:/sbin:/usr/sbin',
    command => "rm -rf ${destination}; rm -rf ${destination}.wgetrc",
    cwd     => $real_target_dir,
  }
}
