HOSTNAME = $(shell hostname)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

switch:
	nh os switch '.?submodules=1' -H ${HOSTNAME} -L

switch-debug:
	nh os switch '.?submodules=1' -H ${HOSTNAME} -L --option eval-cache false --show-trace

boot:
	nh os boot '.?submodules=1' -H ${HOSTNAME} -L --option eval-cache false --show-trace

test:
	nh os test '.?submodules=1' -H ${HOSTNAME} -L --option eval-cache false --show-trace

rekey:
	agenix --extra-flake-params '/?submodules=1' rekey

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
	nh os build-image '.?submodules=1' -H minimal-x86 --image-variant iso-installer

rubeus-iso:
	nh os build-image '.?submodules=1' -H rubeus-install --image-variant iso-installer --impure

hedwig-switch:
# make hedwig-switch ip=<address>
	nh os switch '.?submodules=1' -H hedwig --build-host ferran@localhost --target-host root@$(ip)

dobby-switch:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nh os switch '.?submodules=1' -H dobby --build-host root@dobby --target-host root@dobby

rubeus-switch:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nh os switch '.?submodules=1' -H rubeus --build-host ferran@localhost --target-host root@rubeus

rowling-switch:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nh os switch '.?submodules=1' -H rowling --build-host root@79.72.48.70 --target-host root@79.72.48.70

rowling-switch-first-time:
	NIX_SSHOPTS="-o IdentityAgent=/run/user/1000/gnupg/S.gpg-agent.ssh" \
	nh os switch '.?submodules=1' -H rowling --build-host root@79.72.48.70 --target-host root@79.72.48.70 --install-bootloader

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
	nh os switch '.?submodules=1' -H ${HOSTNAME} -L --build-host root@$(ip) --target-host ferran@localhost
