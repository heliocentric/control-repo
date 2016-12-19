# vim: set expandtab:
# Ensures the Vagrant user has the appropriate permissions
class site::vagrant_user {
  pam::access::manage { 'vagrant':
    permission =>  '+',
    users      =>  '(vagrant)',
    origins    =>  ['ALL'],
  }
  sudo::user_specification { 'vagrant_sudosh':
    user_list =>  'vagrant',
    host_list =>  'ALL',
    runas     =>  'ALL',
    cmnd      =>  '/usr/bin/sudosh',
    passwd    =>  false,
  }
  sudo::user_specification { 'vagrant_ssh':
    user_list =>  'vagrant',
    passwd    =>  false,
    cmnd      =>  'ALL',
  }
  sudo::default_entry { 'vagrant':
    def_type =>  'user',
    target   =>  'vagrant',
    content  =>  ['!requiretty'],
  }
}
