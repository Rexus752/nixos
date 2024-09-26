{ lib, config, pkgs, ... }:

with lib.hm.gvariant;

{

	home = {
		username = "manuel";
		homeDirectory = "/home/manuel";
		
		# This value determines the Home Manager release that your configuration is
		# compatible with. This helps avoid breakage when a new Home Manager release
		# introduces backwards incompatible changes.
		#
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "24.05"; # Please read the comment before changing.
	};
	
	xdg.desktopEntries = {
	 	obsidianPersonalVault = {
			name = "Obsidian - Vault Personale";
			type = "Application";
			exec = "obsidian obsidian://vault/VaultPersonale";
			icon = "/home/manuel/Manuel/Obsidian/VaultPersonale/icon.png";
			terminal = false;
			mimeType = [ "x-scheme-handler/obsidian" ];
		};
	 	obsidianDigitalGarden = {
			name = "Obsidian - Giardino Digitale";
			type = "Application";
			exec = "obsidian obsidian://vault/GiardinoDigitale";
			icon = "/home/manuel/Manuel/Obsidian/GiardinoDigitale/quartz/static/icon.png";
			terminal = false;
			mimeType = [ "x-scheme-handler/obsidian" ];
		};
	};

	programs = {
		bash = {
			enable = true;
			# Restart your shell when changes are applied!
			shellAliases = {
				push = "sudo git push -u origin master";
				screenoff = "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.SetActive boolean:true";
				# Obsidian Quartz
					quartzsync = ''
						cd "/home/manuel/Manuel/Obsidian/GiardinoDigitale"
						sudo npx quartz sync --no-pull
						sudo chown manuel "/home/manuel/Manuel/Obsidian/GiardinoDigitale/content" -R
					'';
					quartzlocal = ''
						cd "/home/manuel/Manuel/Obsidian/GiardinoDigitale"
						npx quartz build --serve
					'';
				# Nix
					rebuild = "
						sudo nixos-rebuild switch --flake /home/manuel/nixos/#default
						sudo systemctl restart home-manager-manuel.service
					";
					editconfig = "sudo nano /home/manuel/nixos/hosts/default/configuration.nix";
					edithome = "sudo nano /home/manuel/nixos/hosts/default/home.nix";
					genlist = "nix profile history --profile /nix/var/nix/profiles/system";
			};
			# For aliases with arguments, use programs.bash.bashrcExtra
			bashrcExtra = ''
				ytdl() { yt-dlp -x "$1" --audio-format mp3 -P "/home/manuel/Desktop" --embed-metadata --add-metadata --embed-thumbnail; }
			'';
		};
		git = {
			enable = true;
			userName = "Rexus752";
			userEmail = "t.rexus752@gmail.com";
		};
	};

	dconf = {
		enable = true;
		settings = {
			# General
				"org/gnome/desktop/interface" = {
					color-scheme = "prefer-dark";
					enable-hot-corners = false;
					overlay-scrolling = false;
					clock-show-seconds = true;
					gtk-enable-primary-paste = false;  # No middle-click paste
				};
				"org/gnome/desktop/notifications" = {
					show-in-lock-screen = true;
				};
				"org/gnome/desktop/wm/preferences" = {
					button-layout = "appmenu:minimize,maximize,close";
				};
				"org/gnome/mutter" = {
					edge-tiling = true;
					dynamic-workspaces = true;
					workspaces-only-on-primary = false;
				};
				"org/gnome/shell/app-switcher" = {
					current-workspace-only = false;
				};
				"org/gnome/shell/keybindings" = {
					show-screenshot-ui = [''<Shift><Super>s''];  # Shift+Win+S
				};
				"org/gnome/desktop/a11y/interface" = {
					show-status-shapes = true;
				};
				"org/gnome/settings-daemon/plugins/color" = {
					night-light-enabled = true;
					night-light-schedule-automatic = true;
					night-light-temperature = (mkVariant (mkUint32 2700));
				};
				"org/gnome/settings-daemon/plugins/power" = {
					idle-dim = true;
					power-saver-profile-on-low-battery = false;
					sleep-inactive-battery-type = "suspend";
					sleep-inactive-battery-timeout = 900;
					sleep-inactive-ac-type = "suspend";
					sleep-inactive-ac-timeout = 900;
					power-button-action = "interactive";  # Power-off	
				};
				"org/gnome/desktop/session" = {
					idle-delay = (mkVariant (mkUint32 300));
				};
			"org/gnome/calendar" = {
				active-view = "month";
			};
			"org/gnome/clocks" = {
				locations = [
					(mkVariant (mkTuple [
						(mkUint32 2)
						(mkVariant (mkTuple [
							"Turin" "LIMF" true
							[ (mkTuple [ (mkDouble 0.78917971592786684) (mkDouble 0.1335176877775662) ]) ]
							[ (mkTuple [ (mkDouble 0.78627082802344539) (mkDouble 0.1338085818039961) ]) ]
						]))
					]))
					(mkVariant (mkTuple [
						(mkUint32 2)
						(mkVariant (mkTuple [
							"Matera" "LIBV" true
							[ (mkTuple [ (mkDouble 0.71151256421411913) (mkDouble 0.29554241418660898) ]) ]
							[ (mkTuple [ (mkDouble 0.70976723496212479) (mkDouble 0.28972465583105872) ]) ]
						]))
					]))
				];
			};
			# Weather
				"org/gnome/shell/weather" = {
					locations = [
						(mkVariant (mkTuple [
							(mkUint32 2)
							(mkVariant (mkTuple [
								"Turin" "LIMF" true
								[ (mkTuple [ (mkDouble 0.78917971592786684) (mkDouble 0.1335176877775662) ]) ]
								[ (mkTuple [ (mkDouble 0.78627082802344539) (mkDouble 0.1338085818039961) ]) ]
							]))
						]))
						(mkVariant (mkTuple [
							(mkUint32 2)
							(mkVariant (mkTuple [
								"Matera" "LIBV" true
								[ (mkTuple [ (mkDouble 0.71151256421411913) (mkDouble 0.29554241418660898) ]) ]
								[ (mkTuple [ (mkDouble 0.70976723496212479) (mkDouble 0.28972465583105872) ]) ]
							]))
						]))
					];
				};
				"org/gnome/Weather" = {
					locations = [
						(mkVariant (mkTuple [
							(mkUint32 2)
							(mkVariant (mkTuple [
								"Turin" "LIMF" true
								[ (mkTuple [ (mkDouble 0.78917971592786684) (mkDouble 0.1335176877775662) ]) ]
								[ (mkTuple [ (mkDouble 0.78627082802344539) (mkDouble 0.1338085818039961) ]) ]
							]))
						]))
						(mkVariant (mkTuple [
							(mkUint32 2)
							(mkVariant (mkTuple [
								"Matera" "LIBV" true
								[ (mkTuple [ (mkDouble 0.71151256421411913) (mkDouble 0.29554241418660898) ]) ]
								[ (mkTuple [ (mkDouble 0.70976723496212479) (mkDouble 0.28972465583105872) ]) ]
							]))
						]))
					];
				};
				"org/gnome/GWeather4" = {
					temperature-unit = "centigrade";
				};
			# Nautilus (File Explorer)
				"org/gtk/gtk4/settings/file-chooser" = {
					show-hidden = true;
					sort-directories-first = true;
				};
				"org/gnome/nautilus/icon-view" = {
					default-zoom-level = "small-plus";
					captions = ["size" "none" "none"];
				};
				"org/gnome/nautilus/list-view" = {
					use-tree-view = true;
					default-zoom-level = "small";
				};
				"org/gnome/nautilus/preferences" = {
					click-policy = "double";
					show-create-link = true;
					show-delete-permanently = true;
					recursive-search = "always";
					show-image-thumbnails = "always";
					show-directory-item-counts = "always";
					date-time-format = "simple";
				};
			"org/gnome/TextEditor" = {
				show-line-numbers = true;
				# tab-width = (mkVariant (mkUint32 4));  # Doesn't work
				wrap-text = true;
				spellcheck = false;
				style-scheme = "Adwaita-dark";
				highlight-current-line = true;
				show-map = true;
			};
			"org/gnome/shell" = {
				favorite-apps = [
					"org.gnome.Settings.desktop"
					"org.gnome.SystemMonitor.desktop"
					"org.gnome.Console.desktop"
					"org.gnome.Nautilus.desktop"
					"org.gnome.TextEditor.desktop"
					"org.gnome.Calendar.desktop"
					"org.gnome.Calculator.desktop"
					"firefox.desktop"
					"org.telegram.desktop.desktop"
					"youtube-music.desktop"
					"discord.desktop"
					"obsidian.desktop"
					"obsidianPersonalVault.desktop"
					"obsidianDigitalGarden.desktop"
					"wine-Programs-Arobas Music-Guitar Pro 8-Guitar Pro 8.desktop"
				];
				disable-user-extensions = false;
				enabled-extensions = [
					"apps-menu@gnome-shell-extensions.gcampax.github.com"
					"clipboard-history@alexsaveau.dev"
					"dash-to-panel@jderose9.github.com"
					"notification-timeout@chlumskyvaclav.gmail.com"
					"places-menu@gnome-shell-extensions.gcampax.github.com"
					"drive-menu@gnome-shell-extensions.gcampax.github.com"
					"steal-my-focus-window@steal-my-focus-window"
				];
			};
			"org/gnome/shell/extensions/clipboard-history" = {
				window-width-percentage = 33;
				history-size = 1000;
				cache-size = 100;
				cache-only-favorites = false;
				move-item-first = true;
				strip-text = false;
				paste-on-selection = true;
				process-primary-selection = false;
				display-mode = 0;
				disable-down-arrow = true;
				notify-on-copy = false;
				confirm-clear = true;
				enable-keybindings = true;
			};
			"org/gnome/shell/extensions/dash-to-panel" = {
				# Position
					intellihide = (mkVariant (mkBoolean false));
					panel-element-positions-monitors-sync = (mkVariant (mkBoolean true));
					panel-positions = ''{"0":"BOTTOM"}'';
					panel-sizes = ''{"0":36}'';
					panel-lengths = ''{"0":100}'';
					# Applications Button
						show-apps-icon-side-padding = (mkVariant (mkUint32 0));
						show-apps-override-escape = (mkVariant (mkBoolean true));
					# Desktop Button
						showdesktop-button-width = (mkVariant (mkUint32 8));
						desktop-line-use-custom-color = (mkVariant (mkBoolean false));
						show-showdesktop-hover = true;
						show-showdesktop-delay = 200;
						show-showdesktop-time = 200;
					panel-element-positions = ''{"0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":false,"position":"stackedBR"},{"element":"dateMenu","visible":false,"position":"stackedBR"},{"element":"systemMenu","visible":false,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'';
				# Style
					appicon-margin = 0;
					appicon-padding = 6;
					# App Icon Animation
						animate-appicon-hover = true;
						animate-appicon-hover-animation-type = "SIMPLE";
						/* Doesn't work
						animate-appicon-hover-animation-duration = (mkVariant (mkUint32 100));
						animate-appicon-hover-animation-rotation = 0;
						animate-appicon-hover-animation-travel = (mkVariant (mkDouble 0.5));
						animate-appicon-hover-animation-zoom = 1;
						animate-appicon-hover-animation-convexity = 0;
						animate-appicon-hover-animation-extent = 1;
						*/
					appicon-style = "NORMAL";
					dot-position = "BOTTOM";
					# Running Indicator
						focus-highlight = true;
						focus-highlight-dominant = true;
						focus-highlight-opacity = 25;
						dot-size = 3;
						dot-color-dominant = true;
						dot-color-override = false;
					dot-style-focused = "SOLID";
					dot-style-unfocused = "DASHES";
					trans-use-custom-bg = false;
					trans-use-custom-opacity = false;
					trans-use-custom-gradient = false;
				# Behavior
					# Applications
						show-favorites = true;
						show-favorites-all-monitors = true;
						show-running-apps = true;
						group-apps = true;
						progress-show-count = false;
					# Hover
						show-window-previews = true;
						# Window Preview
							show-window-previews-timeout = 200;
							window-preview-hide-immediate-click = false;
							leave-timeout = 50;
							window-preview-animation-time = 200;
							preview-middle-click-close = false;
							window-preview-size = 150;
							window-preview-aspect-ratio-x = 16;
							window-preview-fixed-x = true;
							window-preview-aspect-ratio-y = 9;
							window-preview-fixed-y = true;
							window-preview-padding = 4;
							preview-use-custom-opacity = false;
							window-preview-title-position = "TOP";
							window-preview-show-title = true;
							window-preview-use-custom-icon-size = false;
							window-preview-title-font-size = 14;
							window-preview-title-font-weight = "bold";
							window-preview-title-font-color = "#dddddd";
							peek-mode = true;
							enter-peek-mode-timeout = 500;
							peek-mode-opacity = 50;
						show-tooltip = true;
					# Isolate
						isolate-workspaces = false;
						isolate-monitors = false;
						overview-click-to-exit = false;  # What does this do?
						hide-overview-on-startup = false;  # What does this do?
				# Action
					click-action = "CYCLE";
					# Shift & Middle-click Behavior
						shift-click-action = "LAUNCH";
						middle-click-action = "QUIT";
						shift-middle-click-action = "LAUNCH";
					scroll-panel-action = "SWITCH_WORKSPACE";
					# Panel Scroll Behavior
						scroll-panel-delay = (mkVariant (mkUint32 0));
						scroll-panel-show-ws-popup = true;
					scroll-icon-action = "PASS_THROUGH";
					# Icon Scroll Behavior
						scroll-icon-delay = (mkVariant (mkUint32 0));
					hot-keys = false;
				# Fine-Tune
					tray-size = 0;
					leftbox-size = 0;
					tray-padding = -1;
					status-icon-padding = -1;
					leftbox-padding = -1;
					animate-app-switch = true;
					animate-window-launch = true;
					stockgs-keep-dash = false;  # What does this do?
					stockgs-keep-top-panel = true;
					stockgs-panelbtn-click-only = false;  # What does this do?
					stockgs-force-hotcorner = false;  # What does this do?
					# Secondary Menu Options
						secondarymenu-contains-appmenu = false;  # What does this do?
						secondarymenu-contains-showdetails = false;  # What does this do?
			};
			"org/gnome/shell/extensions/notification-timeout" = {
				ignore-idle = true;
				always-normal = true;
				timeout = (mkVariant (mkUint32 3000));
			};
		};
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
