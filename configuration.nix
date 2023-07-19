{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/headless.nix")
  ];

  nixpkgs.overlays = [
    (self: super: {
      systemd = super.systemd.override {
        pname = "systemd-minimal";
        withAcl = false;
        withAnalyze = false;
        withApparmor = false;
        withAudit = false;
        withCompression = false;
        withCoredump = false;
        withCryptsetup = false;
        withDocumentation = false;
        withEfi = false;
        withFido2 = false;
        withHostnamed = false;
        withHomed = false;
        withHwdb = false;
        withImportd = false;
        withLibBPF = false;
        withLibidn2 = false;
        withLocaled = false;
        withLogind = true;
        withMachined = false;
        withNetworkd = false;
        withNss = false;
        withOomd = false;
        withPCRE2 = false;
        withPam = true;
        withPolkit = false;
        withPortabled = false;
        withRemote = false;
        withResolved = false;
        withShellCompletions = false;
        withTimedated = false;
        withTimesyncd = false;
        withTpm2Tss = false;
        withUserDb = false;
      };
    })
  ];

  # Minify systemd
  systemd.coredump.enable = false;
  services.timesyncd.enable = false;
  services.udev.enable = false;
  systemd.oomd.enable = false;
  services.nscd.enable = false;

  services.dbus.enable = lib.mkForce false;

  # Disable systemd-logind
  # NOTE: modules/system/boot/systemd/logind.nix
  environment.etc."systemd/logind.conf".enable = false;
  systemd.services.systemd-logind.enable = false;

  system.nssModules = lib.mkForce [];
  security.pam.services.su.forwardXAuth = lib.mkForce false;
  fonts.fontconfig.enable = false;

  # only add strictly necessary modules
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = ["ext4"];
  # boot.initrd.enable = false;

  # Requires patch to make-disk-image if you want to buile raw-efi image.
  # It should use tools from pkgs.nixos-install-tools instead of system.build.{nixos-install,nixos-enter}
  nix.enable = false;

  boot.enableContainers = false;

  environment.defaultPackages = lib.mkForce [];
  environment.systemPackages = lib.mkForce [];

  environment.etc = {
    "nanorc".enable = false;
    "tmpfiles.d".enable = false;
  };
}
