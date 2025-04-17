{inputs, ...}: {
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = true;

    config = {
      frameless = true;
    };

    discord.enable = true;
    vesktop.enable = false;
  };
}
