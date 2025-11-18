{
lib,
config,
...
}:
{
  options = {
    zsh.enable = lib.mkEnableOption "enables zsh";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      dirHashes = {
        work = "~/work";
        personal = "~/personal";
        dl = "~/Downloads";
      };
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = "eval \"$(direnv hook zsh)\"\n";
    };

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "robbyrussell";
    };
  };
}
