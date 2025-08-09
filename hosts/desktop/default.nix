{
  config,
  ...
}: {
  
  imports = [
    ./hardware-configuration.nix
  ];


  home-manager = {
    users = {
      ${config.username} = { ... }: {

        # Modules
        imports = [
          ./modules/windowmanager
        ];

      };
    };
  };


}
