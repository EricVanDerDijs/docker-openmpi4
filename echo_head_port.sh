docker ps | grep head --color=none | sed 's/.*0.0.0.0://g' | sed 's/->22.*//g'
