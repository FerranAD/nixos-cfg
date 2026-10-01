{ domain, entries }:
{
  routers = builtins.mapAttrs (
    name: entry:
    assert entry ? url || entry ? service;
    {
      entryPoints = [ "websecure" ];
      rule = "Host(`${entry.host or name}.${domain}`)";
      service = entry.service or name;
      tls.certResolver = "letsencrypt";
    }
    // (if entry ? middlewares then { inherit (entry) middlewares; } else { })
  ) entries;

  services = builtins.listToAttrs (
    map (name: {
      name = entries.${name}.service or name;
      value.loadBalancer.servers = [ { inherit (entries.${name}) url; } ];
    }) (builtins.filter (name: entries.${name} ? url) (builtins.attrNames entries))
  );
}
