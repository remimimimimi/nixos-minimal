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
  #   "bashrc".enable = false;
  #   "modules-load.d/nixos.conf".enable = false;
  #   "pam.d/systemd-user".enable = false;
  #   "ssl/certs/ca-certificates.crt".enable = false;
  #   "binfmt.d/nixos.conf".enable = false;
    "nanorc".enable = false;
  #   "pam.d/useradd".enable = false;
  #   "ssl/trust-source".enable = false;
  #   "dbus-1".enable = false;
  #   "netgroup".enable = false;
  #   "pam.d/userdel".enable = false;
  #   "sudoers".enable = false;
  #   "default/useradd".enable = false;
  #   "nsswitch.conf".enable = false;
  #   "pam.d/usermod".enable = false;
  #   "sysctl.d/60-nixos.conf".enable = false;
  #   "dhcpcd.exit-hook".enable = false;
  #   "os-release".enable = false;
  #   "pam.d/vlock".enable = false;
  #   "systemd/journald.conf".enable = false;
  #   "fstab".enable = false;
  #   "pam.d/chfn".enable = false;
  #   "pam.d/xlock".enable = false;
  #   "systemd/logind.conf".enable = false;
  #   "fuse.conf".enable = false;
  #   "pam.d/chpasswd".enable = false;
  #   "pam.d/xscreensaver".enable = false;
  #   "systemd/sleep.conf".enable = false;
  #   "host.conf".enable = false;
  #   "pam.d/chsh".enable = false;
  #   "pam/environment".enable = false;
  #   "systemd/systemcfg.environment.etc.hostname".enable = false;
  #   "pam.d/groupadd".enable = false;
  #   "pki/tls/certs/ca-bundle.crt".enable = false;
  #   "systemd/system-generators".enable = false;
  #   "hosts".enable = false;
  #   "pam.d/groupdel".enable = false;
  #   "profile".enable = false;
  #   "systemd/system-shutdown".enable = false;
  #   "inputrc".enable = false;
  #   "pam.d/groupmems".enable = false;
  #   "protocols".enable = false;
  #   "systemd/system.conf".enable = false;
  #   "issue".enable = false;
  #   "pam.d/groupmod".enable = false;
  #   "pulse/client.conf".enable = false;
  #   "systemd/user".enable = false;
  #   "kbd".enable = false;
  #   "pam.d/i3lock".enable = false;
  #   "resolvconf.conf".enable = false;
  #   "systemd/user.conf".enable = false;
  #   "locale.conf".enable = false;
  #   "pam.d/i3lock-color".enable = false;
  #   "rpc".enable = false;
  #   "terminfo".enable = false;
  #   "login.defs".enable = false;
  #   "pam.d/login".enable = false;
  #   "samba/smb.conf".enable = false;
    "tmpfiles.d".enable = false;
  #   "lsb-release".enable = false;
  #   "pam.d/other".enable = false;
  #   "services".enable = false;
  #   "vconsole.conf".enable = false;
  #   "lvm/lvm.conf".enable = false;
  #   "pam.d/passwd".enable = false;
  #   "set-environment".enable = false;
  #   "zoneinfo".enable = false;
  #   "modprobe.d/debian.conf".enable = false;
  #   "pam.d/runuser".enable = false;
  #   "shells".enable = false;
  #   "modprobe.d/nixos.conf".enable = false;
  #   "pam.d/runuser-l".enable = false;
  #   "ssh/ssh_config".enable = false;
  #   "modprobe.d/systemd.conf".enable = false;
  #   "pam.d/su".enable = false;
  #   "ssh/ssh_known_hosts".enable = false;
  #   "modprobe.d/ubuntu.conf".enable = false;
  #   "pam.d/sudo".enable = false;
  #   "ssl/certs/ca-bundle.crt".enable = false;
  };
}
