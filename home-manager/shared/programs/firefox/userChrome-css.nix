{config}:
with config.lib.stylix.colors;
/*
Theme stolen and modified from some person on discord
*/
  ''
    :root {
        --inactive-window-transition: none !important;
        --tab-border-radius: 0 !important;

        --toolbarbutton-border-radius: 0px !important;
        --toolbarbutton-outer-padding: 0px !important;
        --toolbar-bgcolor: var(--bg) !important;
        --toolbar-color: var(--fg) !important;
        --toolbar-start-end-padding: 0px !important;

        --toolbox-non-lwt-bgcolor: var(--accent) !important;
      --toolbox-non-lwt-textcolor: var(--accent-fg) !important;
        --toolbox-non-lwt-bgcolor-inactive: hsla(var(--fg-h), var(--fg-s), var(--fg-l), var(--bg-opacity)) !important;
      --toolbox-non-lwt-textcolor-inactive: var(--fg) !important;
    }

    :root {
        background-color: transparent !important;
    }
    #navigator-toolbox,
    #nav-bar {
        border: none !important;
    }

    /* tabs */
    #tabbrowser-tabs {
        border: none !important;
        padding: 0 !important;
        margin: 0 !important;
    }
    #TabsToolbar:has(.tabbrowser-tab:only-of-type) {
        display: none !important;
    }
    .tabbrowser-tab {
        padding: 0 !important;
        margin: 0 !important;
        /* max-width: 100% !important; */
        width: 100% !important;
        --tab-block-margin: 0px !important;
        --tab-min-height: 24px !important;
    }
    .tab-background {
        box-shadow: none !important;
    }
    .tab-secondary-label {
        display: none !important;
    }
    .tab-close-button {
        margin-inline-end: 0 !important;
    }

    /* toolbar */
    #back-button,
    #forward-button,
    #reload-button {
        display: none !important;
    }
    #navigator-toolbox {
        z-index: 999 !important;
    }
    #nav-bar {
        --urlbar-height: 32px;

        position: fixed !important;
        bottom: 0 !important;
        width: 100% !important;

        &:not(:has(#urlbar[focused])) {
            bottom: calc(var(--urlbar-height) * -1) !important;

            #urlbar-container {
                opacity: 0 !important;
            }
        }
    }
    #urlbar-container {
        --urlbar-container-height: var(--urlbar-height) !important;
    }
  ''
