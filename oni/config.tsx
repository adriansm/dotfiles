import * as React from "react"
import * as Oni from "oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
  console.log("config activated")
}

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.log("config deactivated")
}

export const configuration = {
  activate,
  "oni.loadInitVim": true,
  "oni.useDefaultConfig": false,

  //"oni.bookmarks": ["~/Documents"],
  "editor.fontSize": "13px",
  "editor.fontFamily": "SauceCodePro Nerd Font",

  // UI customizations
  "ui.colorscheme"           : "n/a",
  "ui.animations.enabled"    : true,
  "ui.fontSmoothing"         : "auto",

  "autoClosingPairs.enabled" : false, // disable autoclosing pairs
  "commandline.mode"         : false, // Do not override commandline UI
  "wildmenu.mode"            : false, // Do not override wildmenu UI,
  //"tabs.mode"                : "native", // Use vim's tabline, need completely quit Oni and restart a few times
  "statusbar.enabled"        : false, // use vim's default statusline
  //"sidebar.enabled"          : false, // sidebar ui is gone
  "sidebar.default.open"     : false, // the side bar collapse
  //"learning.enabled"         : false, // Turn off learning pane
  //"achievements.enabled"     : false, // Turn off achievements tracking / UX
  "editor.typingPrediction"  : false, // Wait for vim's confirmed typed characters, avoid edge cases
  //"editor.textMateHighlighting.enabled" : false, // Use vim syntax highlighting
}
