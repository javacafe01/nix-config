{
  config,
  pkgs,
  ...
}: {
  programs.discocss = {
    enable = true;

    css = with config.lib.stylix.colors; ''
      :root {
           --background-primary : #${base00};
           --background-secondary : #${base00};
           --background-secondary-alt : #${base00};
           --background-tertiary : #${base00};
           --background-floating : #${base00};
           --header-primary : #ffffff;
           --interactive-normal : #ffffff;
           --interactive-hover : #ECEFF4;
           --interactive-active : #ECEFF4;
           --interactive-muted : #ffffff;
           --text-normal : #ffffff;
           --text-link : #a5a9bd;
           --text-muted : #ffffff;
           --channeltextarea-background : #${base08};
           --text-warning : #e06c75;
           --brand-experiment : #434C5E !important;
         }
         .container-1D34oG > div {
           background-color : var(--background-primary);
           border-left: 2px solid #${base08};
           border-top: 2px solid #${base08};
         }
         .item-3HknzM[aria-label~=Add] {
           background-color : #434C5E !important;
         }
         nav[aria-label="Servers sidebar"] {
          border-top: 2px solid #${base08};
          border-right: 2px solid #${base08};
          border-radius: 0 15px 0 0;
          margin-right: 20px;
        }
         .membersWrap-2h-GB4 {
           min-width : 0;
           border-top: 2px solid #${base08};
           border-left: 2px solid #${base08};
         }
         .panels-j1Uci_ {
           border-radius: 15px 15px 15px 15px;
           border: 2px solid #${base08};
           background-color: #${base00};
           margin: 0 10px 10px 10px;
         }
         .root-1gCeng,
         .footer-2gL1pp {
           background-color: var(--background-primary) !important;
                border: 2px solid #${base08};
         }
    '';

    discordPackage = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = false;
    };
  };
}
