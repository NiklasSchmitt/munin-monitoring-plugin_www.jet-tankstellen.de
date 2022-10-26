# munin-monitoring plugin for JET-Tankstellen
this plugin can monitor one fuel type for one JET-Tankstelle. This plugin is currently under development and not finished yet.
It takes some manualy configuration and has a lot of hardcoded stuff...
## configuration
* set `$url` to the correct Tankstelle that you want to monitor. for example `https://www.jet-tankstellen.de/tankstellen/hamburg/neuer-kamp-31/`
* maybe change the (currently) hardcoded fuel type from `SUPER` to `DIESEL` or something else. Be careful with the whitespaces in perl regex ;-)
* configure some warning & critical prices in your `/etc/munin/plugin-conf.d/munin-node` that you get notified
