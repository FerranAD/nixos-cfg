HOSTNAME = $(shell hostname)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

switch:
	nixos-rebuild switch --use-remote-sudo --flake .#${HOSTNAME} -L --option eval-cache false --show-trace