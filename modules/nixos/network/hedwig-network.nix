{...}:
{
  networking = {
    firewall.enable = false;
    hostName = "hedwig";
    networkmanager.enable = true;
    wireless = {
      interfaces = [ "wlan0" ];
      enable = false;
    };
    nftables =
      let
        wanIf = "end0";
        tailscale_ip_client = "100.78.176.53";
        portLow = "18000";
        portHigh = "34000";
      in
      {
        enable = true;
        
        ruleset = ''
          table ip nat {
            chain prerouting {
              type nat hook prerouting priority 0;

              # Forward TCP + UDP port range from A's WAN -> B via Tailscale
              iifname "${wanIf}" tcp dport ${portLow}-${portHigh} dnat to ${tailscale_ip_client}
              iifname "${wanIf}" udp dport ${portLow}-${portHigh} dnat to ${tailscale_ip_client}
            }

            chain postrouting {
              type nat hook postrouting priority 100;

              # SNAT on the tailscale leg so A accepts the packets (appears from B's 100.x)
              oifname "tailscale0" ip daddr ${tailscale_ip_client} tcp dport ${portLow}-${portHigh} masquerade
              oifname "tailscale0" ip daddr ${tailscale_ip_client} udp dport ${portLow}-${portHigh} masquerade

              oifname "${wanIf}" masquerade
            }
          }
        '';
      };
  };
}