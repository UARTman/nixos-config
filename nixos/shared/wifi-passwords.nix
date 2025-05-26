{ config, ... }:

{
  sops.secrets."wireless.env" = {
    sopsFile = ../../secrets/shared.yaml;
  };
  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wireless.env".path ];
      profiles = {
        inetcom457 = {
          connection = {
            id = "inetcom457";
            interface-name = "wlp0s20f3";
            permissions = "user:uartman:;";
            type = "wifi";
            uuid = "912e0f35-2e45-4648-a49a-fefb70a6d49a";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "inetcom457";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$inetcom457_psk";
            leap-password-flags = "1";
            psk-flags = "1";
            wep-key-flags = "1";
          };
        };
        ripa = {
          "802-1x" = {
            eap = "peap;";
            identity = "$ripa_user";
            password = "$ripa_pass";
            password-flags = "1";
            phase2-auth = "mschapv2";
          };
          connection = {
            id = "ripa";
            interface-name = "wlp0s20f3";
            permissions = "user:uartman:;";
            type = "wifi";
            uuid = "bfbe1645-4705-48e6-8bab-00399433c56a";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "stable-privacy";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "ripa";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-eap";
          };
        };
      };
    };
  };
}
