{ config, pkgs, ... }:
{
  imports = [ ./base.nix ];
  home = {
    username = "root";
    homeDirectory = "/root";
  };
}
