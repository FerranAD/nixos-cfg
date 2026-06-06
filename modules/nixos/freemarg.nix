{
  config,
  ...
}:
{
  virtualisation.oci-containers.containers.gluetun = {
    image = "qmcgaw/gluetun";
    autoStart = true;

    environmentFiles = [
      config.age.secrets."airvpn-freemarg.env".path
    ];

    ports = [
      "127.0.0.1:8881:8080/tcp"
    ];

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun"
    ];
  };

  virtualisation.oci-containers.containers.freemarg = {
    image = "freemarg:latest";
    pull = "never";
    autoStart = true;

    dependsOn = [ "gluetun" ];

    extraOptions = [
      "--network=container:gluetun"
    ];

    environmentFiles = [
      config.age.secrets."docker-freemarg.env".path
    ];

    volumes = [
      "/data/freemarg:/app/data"
    ];
  };
}
