{ config, pkgs, ... }:

{
  imports =
    [ # リモートNixOSサーバのhardware-configuration.nix
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking = {
    hostName = "nixos";
    hostId = "242b9113";
    firewall.allowedTCPPorts = [ 80 ];
  };

  i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "jp106";
     defaultLocale = "en_US.UTF-8";
  };

  # プロビジョニングするパッケージ
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services = {

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    httpd = {
      enable       = true;
      adminAddr    = "alice@example.org";
      documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";
    };

  };
   
  # ユーザアカウント
  users.extraUsers.dev = {
    isNormalUser = true;
    createHome = true;
    home = "/home/dev";
    extraGroups = [ "wheel" ];
    uid = 1001;
    useDefaultShell = true;
    # ローカル環境のSSHキーをインポートできる
    openssh.authorizedKeys.keyFiles = [ ~/.ssh/id_rsa.pub ];
  };

}
