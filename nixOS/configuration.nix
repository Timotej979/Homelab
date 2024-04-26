# Import necessary modules
{ config, lib, pkgs, ... }:

# Function to read an environment variable or exit if not set
let
    getEnvOrFail = name:
        let val = lib.getEnv name;
        in if val == null then
            (lib.abort "Required environment variable not set: ${name}")
        else
            val;
in

{
    # Set autoupdate to true to enable automatic updates
    system.autoUpgrade.enable  = true;
    system.autoUpgrade.allowReboot  = true;

    # Set the hostname
    networking.HostName = getEnvOrFail "NIXOS_HOSTNAME";

    # Make sure that the only user is the one we create
    users.mutableUsers = false;

    # Add your new user with username and password from environment variables
    users.extraUser.cluster = getEnvOrFail "NIXOS_USERNAME" or {
        createHome = true;
        home = "/home/cluster";
        uid = 1000;
        group = "users";
        password = getEnvOrFail "NIXOS_PASSWORD";
        shell = pkgs.bashInteractive;
    };

    # Install necessary packages
    environment.systemPackages = with pkgs; [
        terraform
        terraform-provider-proxmox
        terraform-provider-random
        proxmox-ve
    ];

    # Configure Proxmox
    services.proxmox = {
        enable = true;
        firewall = true;
    };

    # Define additional system configurations here
}
