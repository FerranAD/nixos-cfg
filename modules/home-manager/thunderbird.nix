{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    birdtray
    thunderbird
  ];

  programs.thunderbird = {
    profiles.ferran = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
}
