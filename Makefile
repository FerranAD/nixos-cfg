HOSTNAME = $(shell hostname)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

switch:
	nixos-rebuild switch -sudo --flake .?submodules=1#${HOSTNAME} -L

switch-debug:
	nixos-rebuild switch -sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

boot:
	nixos-rebuild boot -sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

test:
	nixos-rebuild test -sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

rekey:
	agenix --extra-flake-params '/?submodules=1' rekey && cd secrets && git add . && git commit -m "build: rekey" && git push && cd ..

lint:
	nixfmt .

update:
	nix flake update

upgrade:
	make update && make switch-debug
