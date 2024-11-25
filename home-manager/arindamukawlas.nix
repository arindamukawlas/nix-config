{ config, pkgs, ... }:
{
  imports = [ ./home.nix ];
  home = {
    username = "arindamukawlas";
    homeDirectory = "/home/arindamukawlas";
  };
}
