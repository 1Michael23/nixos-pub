{
  # Machine-wide Chromium policy. The browser package and profile stay in
  # home-manager; this only writes /etc/chromium/policies.
  programs.chromium = {
    enable = true;
    extraOpts = {
      PasswordManagerEnabled = false;
      AutofillCreditCardEnabled = false;
      BrowserSignin = 0;
      MetricsReportingEnabled = false;
      SafeBrowsingProtectionLevel = 1;
    };
  };
}
