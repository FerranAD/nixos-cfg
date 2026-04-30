HOSTNAME = $(shell hostname)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

switch:
	nixos-rebuild switch --sudo --flake .?submodules=1#${HOSTNAME} -L

switch-debug:
	nixos-rebuild switch --sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

boot:
	nixos-rebuild boot --sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

test:
	nixos-rebuild test --sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

rekey:
	cd secrets && git add . && git commit && cd .. && agenix --extra-flake-params '/?submodules=1' rekey && cd secrets && git add . && git commit -m "build: rekey" && git push && cd ..

lint:
	nixfmt .

update:
	nix flake update

upgrade:
	make update && make switch-debug

hedwig-iso:
	sudo nix build .#hedwig-iso --system aarch64-linux --impure

oracle-iso:
	sudo nix build .#oracle-iso --system aarch64-linux --impure

iso-x86:
	nixos-rebuild build-image --flake \?.submodules=1#minimal-x86 --image-variant iso-installer

rubeus-iso:
	nixos-rebuild build-image --flake \?.submodules=1#rubeus-install --image-variant iso-installer --impure

hedwig-switch:
# make hedwig-switch ip=<address>
	nixos-rebuild --flake .?submodules=1#hedwig --build-host ferran@localhost --target-host root@$(ip) switch;

dobby-switch:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nixos-rebuild --flake .?submodules=1#dobby --build-host root@dobby --target-host root@dobby switch;

rubeus-switch:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nixos-rebuild --flake .?submodules=1#rubeus --build-host root@172.16.106.100 --target-host root@172.16.106.100 switch;

rowling-switch:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nixos-rebuild --flake .?submodules=1#rowling --build-host root@79.72.48.70 --target-host root@79.72.48.70 switch;

rowling-switch-first-time:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nixos-rebuild --flake .?submodules=1#rowling --build-host root@79.72.48.70 --target-host root@79.72.48.70 switch --install-bootloader;

dobby-install:
# make dobby-install ip=<address>
	sudo chown -R ferran:users /etc/nixos/agenix-*
	nixos-anywhere --flake .?submodules=1#dobby-install --build-on remote --target-host root@$(ip) --option pure-eval false --generate-hardware-config nixos-generate-config ./hosts/dobby/hardware-configuration.nix
	sudo chown -R root:root /etc/nixos/agenix-*

rubeus-install:
# make rubeus-install ip=<address>
	sudo chown -R ferran:users /etc/nixos/agenix-*
	nixos-anywhere --flake .?submodules=1#rubeus-install --build-on remote --target-host root@$(ip) --option pure-eval false --generate-hardware-config nixos-generate-config ./hosts/rubeus/hardware-configuration.nix
	sudo chown -R root:root /etc/nixos/agenix-*


switch-remote:
# make switch-remote ip=<remote-ip-address>
	nixos-rebuild switch --sudo --flake .?submodules=1#${HOSTNAME} -L --build-host root@$(ip) --target-host ferran@localhost
