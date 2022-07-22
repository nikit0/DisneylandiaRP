fx_version "bodacious"
game "gta5"

ui_page "gui/index.html"
loadscreen "loading/index.html"

client_scripts {
	"lib/utils.lua",
	"client/*"
}

server_scripts {
	"lib/utils.lua",
	"modules/*"
}

files {
	"loading/*",
	"lib/*",
	"gui/*"
}
