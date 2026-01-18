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
	agenix --extra-flake-params '/?submodules=1' rekey && cd secrets && git add . && git commit -m "build: rekey" && git push && cd ..

lint:
	nixfmt .

update:
	nix flake update

upgrade:
	make update && make switch-debug

hedwig-iso:
	sudo nix build .#hedwig-iso --system aarch64-linux --impure

hedwig-switch:
	@if [ -z "$(ip)" ]; then \
		echo "❌ Error: please run 'make hedwig-switch ip=<address>'"; \
		exit 1; \
	fi
	nixos-rebuild --flake .?submodules=1#hedwig --build-host ferran@localhost --target-host root@$(ip) switch;
