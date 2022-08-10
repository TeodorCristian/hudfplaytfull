fx_version 'adamant'

game 'gta5'

version '1.0.0'

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server/main.lua",
}

client_scripts {
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"config.lua",
	"client/main.lua",
	"client/ui.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/img/*.png',
	'html/*.html',
	'html/ui.html',
	'html/css/main.css',
	'html/css/pricedown_bl-webfont.ttf',
	'html/css/pricedown_bl-webfont.woff',
	'html/css/pricedown_bl-webfont.woff2',
	'html/css/gta-ui.ttf',
	'html/js/loading-bar.js',
	'html/js/app.js',
	'html/css/pdown.ttf',
	'html/css/*.css',
	'html/css/*.ttf',
	'html/css/*.woff',
	'html/css/*.woff2',
	'html/css/*.eot',
	'html/css/*.svg',
	'stream/*',
}