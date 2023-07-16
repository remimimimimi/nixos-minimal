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

      # util-linux = super.util-linux.override {
      #   ncursesSupport = false;
      #   pamSupport = false;
      #   nlsSupport = false;
      #   translateManpages = false;
      # };
    })
  ];

  # boot.kernelPackages = let
  #   kernel = with pkgs;
  #     linuxManualConfig {
  #       inherit stdenv lib;
  #       inherit (pkgs.linux_latest) src version modDirVersion;
  #       configfile = ./kernel.config;
  #       kernelPatches = [
  #         {
  #           # Fix failed oto encode BTF
  #           # https://lore.kernel.org/bpf/57830c30-cd77-40cf-9cd1-3bb608aa602e@app.fastmail.com/T/
  #           name = "systemd-config";
  #           patch = null;
  #           extraConfig = ''
  #             CONFIG_CGROUPS y
  #             CONFIG_INOTIFY_USER y
  #             CONFIG_NET y
  #             CONFIG_CRYPTO_USER_API_HASH y
  #             CONFIG_CRYPTO_HMAC y
  #             CONFIG_CRYPTO_SHA256 y
  #             CONFIG_DMIID y
  #             CONFIG_AUTOFS4_FS y
  #             CONFIG_TMPFS_POSIX_ACL y
  #             CONFIG_TMPFS_XATTR y
  #             CONFIG_SECCOMP y
  #             CONFIG_TMPFS y
  #             CONFIG_MODULES y
  #           '';
  #         }

  #         # {
  #         #   name = "squashfs-config";
  #         #   patch = null;
  #         #   extraConfig = ''

  #         #   '';
  #         # }
  #       ];
  #       # we need this to true else the kernel can't parse the config and
  #       # detect if modules are in used
  #       allowImportFromDerivation = true;
  #     };
  # in
  #   pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor kernel);

  # Minify systemd
  systemd.coredump.enable = false;
  services.timesyncd.enable = false;
  services.udev.enable = false;
  systemd.oomd.enable = false;
  services.nscd.enable = false;

  # Disable systemd-logind
  # NOTE: modules/system/boot/systemd/logind.nix
  # environment.etc."systemd/logind.conf".enable = false;
  # systemd.services.systemd-logind.enable = false;
  # systemd.services."autovt@".enable = false;
  # systemd.services.systemd-user-sessions.enable = false;
  # systemd.services.dbus.enable = false;
  # systemd.services."user@".enable = false;
  # systemd.services."user-runtime-dir@".enable = false;

  system.nssModules = lib.mkForce [];
  security.pam.services.su.forwardXAuth = lib.mkForce false;
  fonts.fontconfig.enable = false;

  # only add strictly necessary modules
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = ["ext4"];

  # Requires patch to make-disk-image. It should use tools from pkgs.nixos-install-tools instead of system.build.{nixos-install,nixos-enter}
  nix.enable = false;

  environment.systemPackages = lib.mkForce [];
}
