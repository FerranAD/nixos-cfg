HOSTNAME = $(shell hostname)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

switch:
	nixos-rebuild switch --use-remote-sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

test:
	nixos-rebuild test --use-remote-sudo --flake .?submodules=1#${HOSTNAME} -L --option eval-cache false --show-trace

rekey:
	agenix --extra-flake-params '/?submodules=1' rekey