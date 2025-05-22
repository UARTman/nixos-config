{ ... }:

{
  boot.loader.systemd-boot.extraEntries = {
    "fedora.conf" = ''
      title Fedora
      efi /EFI/fedora/shimx64.efi
      sort-key z_fedora
    '';
  };

  fileSystems."/mnt/fedora" = {
    device = "/dev/disk/by-uuid/4b484789-f242-47db-b41d-a932e3b12c6a";
    fsType = "btrfs";
  };
}
