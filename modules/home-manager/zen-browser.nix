inputs:
{
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];
  programs.zen-browser = {
    enable = true;
    profiles."default" = {

    };
    policies = {
        DefaultDownloadDirectory = "\${home}/Downloads";
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = false;
          };
        };
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
}

