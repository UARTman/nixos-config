{...}:

{
  sops.defaultSopsFile = ../../secrets/owlbear.yaml;
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.gnupg.sshKeyPaths = [ "/etc/ssh/ssh_host_rsa_key" ];
  # sops.gnupg.home = "/home/uartman/.gnupg";
  sops.secrets.testkey = {};
  # sops.secrets."wireless.env" = {};
}
