{config}:
with config.lib.stylix.colors; ''
  :root {
  	--tab-active-bg-color: #${base00};
  	--tab-inactive-bg-color: #${base01};
  	--tab-active-fg-fallback-color: #eee;		/* color of text in an active tab without a container */
  	--tab-inactive-fg-fallback-color: #888;		/* color of text in an inactive tab without a container */
  	--urlbar-focused-bg-color: #${base02};
  	--urlbar-not-focused-bg-color: #${base02};
  	--toolbar-bgcolor: #${base01} !important;

  	/* try increasing if you encounter problems */
  	--urlbar-height-setting: 40px;
  	--tab-min-height: 40px !important;

  	/* I don't recommend you touch this unless you know what you're doing */
  	/*--arrowpanel-menuitem-padding: 2px !important;*/
  	--arrowpanel-border-radius: 0px !important;
  	--arrowpanel-menuitem-border-radius: 0px !important;
  	--toolbarbutton-border-radius: 0px !important;
  	--toolbar-field-focus-background-color: var(--urlbar-focused-bg-color) !important;
  	--toolbar-field-background-color: var(--urlbar-not-focused-bg-color) !important;
  	--toolbar-field-focus-border-color: transparent !important;
  }

  /* --- GENERAL DEBLOAT ---------------------------------- */

  /* Bottom left page loading status or url preview */
  #statuspanel { display: none !important; }

  /* remove radius from right-click popup */
  menupopup, panel { --panel-border-radius: 0px !important; }
  menu, menuitem, menucaption { border-radius: 0px !important; }

  /* no stupid large buttons in right-click menu */
  menupopup > #context-navigation { display: none !important; }
  menupopup > #context-sep-navigation { display: none !important; }

  /* --- DEBLOAT NAVBAR ----------------------------------- */

  #back-button { display: none; }
  #forward-button { display: none; }
  #reload-button { display: none; }
  #stop-button { display: none; }
  #home-button { display: none; }
  #library-button { display: none; }
  /* #fxa-toolbar-menu-button { display: none; } */
  /* empty space before and after the url bar */
  #customizableui-special-spring1, #customizableui-special-spring2 { display: none; }
  .private-browsing-indicator-with-label { display: none; }

  /* --- STYLE NAVBAR ------------------------------------ */

  /* remove padding between toolbar buttons */
  toolbar .toolbarbutton-1 { padding: 0 0 !important; }

  /* add it back to the downloads button, otherwise it's too close to the urlbar */
  #downloads-button {
  	margin-left: 2px !important;
  }

  /* add padding to the right of the last button so that it doesn't touch the edge of the window */
  #PanelUI-menu-button {
  	padding: 0px 4px 0px 0px !important;
  }

  #urlbar-container {
  	--urlbar-container-height: var(--urlbar-height-setting) !important;
  	margin-left: 0 !important;
  	margin-right: 0 !important;
  	padding-top: 0 !important;
  	padding-bottom: 0 !important;
  	font-family: var(--urlbar-font, 'monospace');
  	font-size: 11px;
  }

  #urlbar {
  	--urlbar-height: var(--urlbar-height-setting) !important;
  	--urlbar-toolbar-height: var(--urlbar-height-setting) !important;
  	min-height: var(--urlbar-height-setting) !important;
  	border-color: var(--lwt-toolbar-field-border-color, hsla(240,5%,5%,.25)) !important;
  }

  #urlbar-input {
  	margin-left: 0.4em !important;
  	margin-right: 0.4em !important;
  }

  #navigator-toolbox {
  	border: none !important;
  }

  /* keep pop-up menus from overlapping with navbar */
  #widget-overflow { margin: 4px !important; }
  #customizationui-widget-panel { margin: 4px !important; }
  #unified-extensions-panel { margin-top: 4px !important; }
  #appMenu-popup { margin-top: 4px !important; }

  /* --- UNIFIED EXTENSIONS BUTTON ------------------------ */

  /* make extension icons smaller */
  #unified-extensions-view {
  	--uei-icon-size: 16px;
  }

  /* hide bloat */
  .unified-extensions-item-message-deck,
  #unified-extensions-view > .panel-header,
  #unified-extensions-view > toolbarseparator,
  #unified-extensions-manage-extensions {
  	display: none !important;
  }

  /* add 3px padding on the top and the bottom of the box */
  .panel-subview-body {
  	padding: 3px 0px !important;
  }

  #unified-extensions-view .toolbarbutton-icon {
  	padding: 0 !important;
  }

  .unified-extensions-item-contents {
  	line-height: 1 !important;
  	white-space: nowrap !important;
  }

  #unified-extensions-panel .unified-extensions-item {
  	margin-block: 0 !important;
  }

  .toolbar-menupopup :is(menu, menuitem), .subview-subheader, panelview
  .toolbarbutton-1, .subviewbutton, .widget-overflow-list .toolbarbutton-1 {
  	padding: 4px !important;
  }

  /* --- DEBLOAT URLBAR ----------------------------------- */

  #pageActionButton { display: none; }
  #pocket-button { display: none; }
  #urlbar-zoom-button { display: none; }
  #tracking-protection-icon-container { display: none !important; }
  /* #reader-mode-button{ display: none !important; } */
  /* #star-button { display: none; } */
  /* #star-button-box:hover { background: inherit !important; } */

  #identity-box { margin-inline-end: 0 !important; }

  /* Go to arrow button at the end of the urlbar when searching */
  #urlbar-go-button { display: none; }

  /* remove container indicator from urlbar */
  #userContext-label, #userContext-indicator { display: none !important;}

  /* --- STYLE TAB TOOLBAR -------------------------------- */

  #titlebar {
  	--proton-tab-block-margin: 0px !important;
  	--tab-block-margin: 0px !important;
  }

  #TabsToolbar, .tabbrowser-tab {
  	max-height: var(--tab-min-height) !important;
  	font-size: 11px !important;
  }

  /* Change color of normal tabs */
  tab:not([selected="true"]) {
  	background-color: var(--tab-inactive-bg-color) !important;
  	color: var(--identity-icon-color, var(--tab-inactive-fg-fallback-color)) !important;
  }

  tab {
  	font-family: var(--tab-font, monospace);
  	font-weight: bold;
  	border: none !important;
  	padding-top: 0 !important;
  }

  .tab-content {
  	padding: 0 0 0 var(--tab-inline-padding);
  }

  .tab-background {
  	margin-block: 0 !important;
  	min-height: var(--tab-min-height);
  	outline-offset: 0 !important;
  }

  /* safari style tab width */
  .tabbrowser-tab[fadein] {
  	max-width: 100vw !important;
  	border: none
  }

  /* Hide close button on tabs */
  #tabbrowser-tabs .tabbrowser-tab .tab-close-button { display: none !important; }

  /* disable favicons in tab */
  /* .tab-icon-stack:not([pinned]) { display: none !important; } */

  .tabbrowser-tab {
  	/* remove border between tabs */
  	padding-inline: 0px !important;
  	/* reduce fade effect of tab text */
  	--tab-label-mask-size: 1em !important;
  	/* fix pinned tab behaviour on overflow */
  	overflow-clip-margin: 0px !important;
  }

  /* Tab: selected colors */
  #tabbrowser-tabs .tabbrowser-tab[selected] .tab-content {
  	background: var(--tab-active-bg-color) !important;
  	color: var(--identity-icon-color, var(--tab-active-fg-fallback-color)) !important;
  }

  /* Tab: hovered colors */
  #tabbrowser-tabs .tabbrowser-tab:hover:not([selected]) .tab-content {
  	background: var(--tab-active-bg-color) !important;
  }

  /* hide window controls */
  .titlebar-buttonbox-container { display: none; }

  /* remove titlebar spacers */
  .titlebar-spacer { display: none !important; }

  /* disable tab shadow */
  #tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
      box-shadow: none !important;
  }

  /* remove dark space between pinned tab and first non-pinned tab */
  #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs]) >
  #tabbrowser-arrowscrollbox >
  .tabbrowser-tab:nth-child(1 of :not([pinned], [hidden])) {
  	margin-inline-start: 0px !important;
  }

  /* remove dropdown menu button which displays all tabs on overflow */
  #alltabs-button { display: none !important }

  /* fix displaying of pinned tabs on overflow */
  #tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
  	height: var(--tab-min-height) !important;
  }

  #tabbrowser-tabs {
  	min-height: var(--tab-min-height) !important;
  }

  /* remove overflow scroll buttons */
  #scrollbutton-up, #scrollbutton-down { display: none !important; }

  /* remove new tab button */
  #tabs-newtab-button {
  	display: none !important;
  }

  /* hide private browsing indicator */
  #private-browsing-indicator-with-label {
  	display: none;
  }

  /* --- AUTOHIDE NAVBAR ---------------------------------- */

  #nav-bar,
  #urlbar {
  	transform: translateY(calc(0px - var(--urlbar-height-setting)));
  	opacity: 0;
  }

  #navigator-toolbox {
  	min-height: var(--tab-min-height) !important;
  	height: var(--tab-min-height) !important;
  }

  #navigator-toolbox:focus-within {
  	min-height: auto !important;
  	height: auto !important;
  	transform: translateY(calc(0px - var(--tab-min-height)));
  }

  #PersonalToolbar {
  	transform: translateY(var(--tab-min-height));
  }

  #TabsToolbar {
  	transform: translateY(var(--tab-min-height));
  }

  #nav-bar:focus-within {
  	transform: translateY(var(--tab-min-height));
  	opacity: 1;
  }

  #urlbar:focus-within {
  	transform: translateY(0);
  	opacity: 1;
  }
''
