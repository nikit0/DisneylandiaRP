fx_version "bodacious"
game "gta5"

ui_page_preload "yes"
ui_page "web-side/index.html"

client_scripts {
  "@vrp/lib/utils.lua",
  "config-side/*",
  "client-side/*"
}

server_scripts {
  "@vrp/lib/utils.lua",
  "config-side/*",
  "server-side/*"
}

files {
  "web-side/*",
  "web-side/**/*"
}