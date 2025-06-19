{ config, lib, pkgs, inputs, ... }:

{

	environment.systemPackages = with pkgs; [
		audacity
        autokey
		cloc
        drawio
		droidcam
		dupeguru
		eartag
		ffmpeg
		file
		htop
		libreoffice-qt6-still
		lollypop
		mupdf
		nicotine-plus
		nvd # Nix/NixOS package version diff tool
		obs-studio
		pinta
		prismlauncher
        putty
		songrec
		spotify
		telegram-desktop
		thunderbird
		tonelib-zoom
        ungoogled-chromium
		ventoy
		vlc
		vscode-fhs
		webcord
		yt-dlp
		# Programming languages
			gcc
			gdb
			gdbgui
			gnumake
            jdk
            jre8
			python3
			R
			rstudio
            ruby
            supercollider
		# Git & GitHub
			gh
			git
			git-credential-manager
		# GNOME stuff
			gnomeExtensions.clipboard-history
			gnomeExtensions.dash-to-panel
			gnomeExtensions.notification-timeout
			gnomeExtensions.steal-my-focus-window
			gnomeExtensions.wallpaper-slideshow
			gnomeExtensions.espresso
			desktop-file-utils
			gnome-tweaks
		# Obsidian & Quartz
			nodejs
			nodePackages.npm
			obsidian
		# Wine
			bottles
			mono
			wineWowPackages.stable
			winetricks
		# Backups Management
			rclone
			restic
		# Compressed Archives
			rar
			zip
			unzip
	];

	nixpkgs.config = {
		allowUnfree = true;
	};
	
	virtualisation.docker.enable = true;
	
	environment.gnome.excludePackages = (with pkgs; [
		epiphany # Browser
		geary # E-Mail
		gnome-calendar
		gnome-connections
		gnome-tour
		totem # Videos
	]);
	
	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.default
	];

	boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
		grub = {
			device = "nodev";
			efiSupport = "true";
			useOSProber = "true";
		};
	};

	services = {
		restic.backups = {
			gdrive = {
				user = "manuel";
				repository = "rclone:gdrive:/backups";
				initialize = true;
				passwordFile = "/home/manuel/nixos/restic_password.txt";
				paths = [
					"/home/manuel/Manuel"
				];
				exclude = [
					"/home/*/.cache"
				];
				timerConfig = {
					OnCalendar = "00:05";
					Persistent = true;
					RandomizedDelaySec = "5h";
				};
				pruneOpts = [ "--keep-last 5" ];
			};
		};
		xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
			xkb.layout = "it";
			excludePackages = [pkgs.xterm];
		};
		printing.enable = true;
		libinput.enable = true;
		openssh.enable = true;
	};

	networking = {
		hostName = "manuel";
		networkmanager.enable = true;
	};

	time.timeZone = "Europe/Rome";
	hardware.pulseaudio.enable = true;

	users.users.manuel = {
		 isNormalUser = true;
		 home = "/home/manuel";
		 initialPassword = "PASSWORD";
		 extraGroups = ["wheel" "networkmanager"];
	};

	nix.settings.experimental-features = ["nix-command" "flakes"];
	home-manager = {
		extraSpecialArgs = {inherit inputs;};
		users = {
			"manuel" = import ./home.nix;
		};
	};
	
	# Temporary workaround for this problem: https://discourse.nixos.org/t/what-gstreamer-plugin-am-i-missing-thats-preventing-me-from-seeing-audio-video-properties/32824
	environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [
		gst-plugins-good
		gst-plugins-bad
		gst-plugins-ugly
		gst-libav
	]);
	
	# To see MIME type:
	# XDG_UTILS_DEBUG_LEVEL=2 xdg-mime query filetype /path/to/file.extension
	xdg.mime = {
		enable = true;
		addedAssociations = {
			/* .code-workspace */ "application/json" = ["code.desktop"];
			/* .gp */ "application/x-gnuplot" = ["wine-Programs-Arobas Music-Guitar Pro 8-Guitar Pro 8.desktop"];
			/* .gp5 */ "application/x-wine-extension-gp5" = ["wine-Programs-Arobas Music-Guitar Pro 8-Guitar Pro 8.desktop"];
			/* .mp3 */ "audio/mpeg" = ["org.gnome.Lollypop.desktop"];
			/* .pdf */ "application/pdf" = ["chromium-browser.desktop"];
		};
		defaultApplications = {
			/* .code-workspace */ "application/json" = ["code.desktop"];
			/* .gp */ "application/x-gnuplot" = ["wine-Programs-Arobas Music-Guitar Pro 8-Guitar Pro 8.desktop"];
			/* .gp5 */ "application/x-wine-extension-gp5" = ["wine-Programs-Arobas Music-Guitar Pro 8-Guitar Pro 8.desktop"];
			/* .mp3 */ "audio/mpeg" = ["org.gnome.Lollypop.desktop"];
			/* .pdf */ "application/pdf" = ["chromium-browser.desktop"];
		};
	};

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.05"; # Did you read the comment?
}

