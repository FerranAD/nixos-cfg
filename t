[1m[33mhosts/albus/configuration.nix[39m[0m[2m --- Nix[0m
[2m51 [0m    defaultUserShell = pkgs.zsh;              [2m51 [0m    defaultUserShell = pkgs.zsh;
[2m52 [0m    users.ferran = {                          [2m52 [0m    users.ferran = {
[2m53 [0m      isNormalUser = true;                    [2m53 [0m      isNormalUser = true;
[31;1m54 [0m      [31mdescription[0m [31m=[0m [31m"Ferran"[0m[31m;[0m                 [2m.. [0m
[2m55 [0m      extraGroups = [                         [2m54 [0m      extraGroups = [
[2m56 [0m        [35m"networkmanager"[0m                      [2m55 [0m        [35m"networkmanager"[0m
[2m57 [0m        [35m"wheel"[0m                               [2m56 [0m        [35m"wheel"[0m
[2m58 [0m        [35m"udev"[0m                                [2m57 [0m        [35m"udev"[0m
[2m59 [0m      ];                                      [2m58 [0m      ];
[2m.. [0m                                              [32;1m59 [0m      [32muid[0m [32m=[0m [32m1000[0m[32m;[0m
[2m60 [0m      packages = [                            [2m60 [0m      packages = [
[2m61 [0m        pkgs.kitty                            [2m61 [0m        pkgs.kitty
[2m62 [0m        pkgs.dolphin                          [2m62 [0m        pkgs.dolphin

