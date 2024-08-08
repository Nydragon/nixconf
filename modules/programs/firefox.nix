# References:
# https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
# https://github.com/gvolpe/nix-config/blob/6feb7e4f47e74a8e3befd2efb423d9232f522ccd/home/programs/browsers/firefox.nix
{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.programs.firefox.enable {
  programs.firefox = {
    package = pkgs.firefox-bin;
    preferencesStatus = "locked";
    preferences = {
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.sponsoredTopSites" = false;
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.bookmark" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.topsites" = false;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.trimHttps" = false;
      "browser.sessionstore.restore_tabs_lazily" = true;
      "browser.uitour.enabled" = false;
      "browser.dataFeatureRecommendations.enabled" = false;
      "browser.translations.automaticallyPopup" = false;
      "browser.translations.enable" = true;
      "browser.preferences.moreFromMozilla" = false;
      "browser.newtabpage.activity-stream.showSearch" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
      "extensions.pocket.enabled" = false;
      "dom.security.https_only_mode" = true;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "cookiebanners.service.mode" = 2;
      "cookiebanners.service.mode.privateBrowsing" = 2;
      # Hides the recommendations tab at about:addons
      "extensions.getAddons.showPane" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "privacy.clearOnShutdown.offlineApps" = true;
      "layout.spellcheckDefault" = true;
    };
    policies = {
      PasswordManagerEnabled = false;
      AutofillCreditCardEnabled = false;
      AutofillAddressEnabled = false;
      # Check about:support for extension/add-on ID strings.
      # WARNING: Does not seem to install extension, i.e useless
      ExtensionSettings =
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        in
        builtins.listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "firefox-translations" "firefox-translations-addon@mozilla.org")
          (extension "private-relay" "private-relay@firefox.com")
          (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
          (extension "duckduckgo-for-firefox" "ddg@search.mozilla.org")
        ];
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };
      DisableFormHistory = true;
      DisableTelemetry = true;
      DisplayMenuBar = "default-off";
      OfferToSaveLogins = false;
      PopupBlocking = {
        Default = true;
        Locked = true;
      };
      StartDownloadsInTempDirectory = true;
      SanitizeOnShutdown = {
        Cookies = true;
        Cache = true;
        FormData = true;
        Locked = true;
      };
      SearchBar = "unified";
      ShowHomeButton = false;
      Permissions = {
        Location = {
          BlockNewRequests = true;
        };
        VirtualReality = {
          BlockNewRequests = true;
        };
        Notifications = {
          BlockNewRequests = true;
        };
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      NoDefaultBookmarks = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
    };
  };
}
