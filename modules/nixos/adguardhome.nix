{ ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    host = "127.0.0.1";
    port = 3000;

    settings = {
      users = [
        {
          name = "admin";
          password = "$2b$05$5Dz60SuUg63kYjFppFbn8u1JN3s6UcZKsQ4Hu02r.48TiZWZ./jS2";
        }
      ];

      clients = {
        persistent = [
          {
            name = "hedwig";
            ids = [ "100.122.252.116" ];
          }
          {
            name = "dobby";
            ids = [ "100.84.147.111" ];
          }
          {
            name = "dobby-local";
            ids = [ "192.168.1.39" ];
          }
          {
            name = "albus";
            ids = [ "100.100.148.39" ];
          }
          {
            name = "pixel";
            ids = [ "100.125.167.53" ];
          }
          {
            name = "pi3";
            ids = [ "100.127.161.24" ];
          }
          {
            name = "bandido";
            ids = [ "100.78.176.53" ];
          }
        ];
        runtime_sources = {
          hosts = true;
          rdns = true;
          arp = true;
          dhcp = true;
          whois = false;
        };
      };

      dns = {
        bind_hosts = [
          "0.0.0.0"
          "::"
        ];
        port = 53;
        upstream_dns = [
          "https://dns.quad9.net/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"
        ];
        cache_enabled = true;
        cache_size = 67108864;
        cache_optimistic = true;
        use_private_ptr_resolvers = true;
        local_ptr_upstreams = [
          "192.168.1.1"
        ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
      };

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS Filter";
          id = 1;
        }

        {
          enabled = true;
          url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt";
          name = "HaGeZi Multi PRO";
          id = 2;
        }

        {
          enabled = true;
          url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.medium.txt";
          name = "HaGeZi TIF Medium";
          id = 3;
        }

        {
          enabled = true;
          url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adguard/dns-rebind-protection.txt";
          name = "HaGeZi DNS Rebind Protection";
          id = 4;
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
