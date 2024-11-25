{ config, pkgs, ... }:
{
  imports = [ ./home.nix ];
  home = {
    username = "root";
    homeDirectory = "/root";
  };
}
