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
  $version = '1.9.18',

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

  # fetch archive from Google
  wget::fetch { 'dogae_fetch_sdk':
    source      =>  "${download_root}${download_leaf}${download_vbridge}${version}${download_ext}",
    destination => "${real_target_dir}/${download_leaf}${download_vbridge}${version}${download_ext}",
    user        => $user,
  }->
  # unpack
  exec { 'dogae_unpack':
    path    => '/bin/:/usr/bin:/sbin:/usr/sbin',
    command => "${command_expand} ${real_target_dir}/${download_leaf}${download_vbridge}${version}${download_ext}",
    cwd     => $real_target_dir,
    user    => $user,
    creates => "${real_target_dir}/${download_leaf}",
  }->
  # delete downloaded archive and mysterious .wgetrc
  exec { 'dogae_cleanup':
    path    => '/bin/:/usr/bin:/sbin:/usr/sbin',
    command => "rm ${real_target_dir}/${download_leaf}${download_vbridge}${version}${download_ext}; rm ${real_target_dir}/${download_leaf}${download_vbridge}${version}${download_ext}.wgetrc",
    cwd     => $real_target_dir,
    user    => $user,
  }
}
