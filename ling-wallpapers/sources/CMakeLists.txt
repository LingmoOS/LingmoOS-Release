cmake_minimum_required(VERSION 3.5)
project(ling-wallpapers)

set(BACKGROUNDS
	default.jpg
	wallpaper-1.jpg
	wallpaper-2.jpg
	wallpaper-3.jpg
)

install(FILES ${BACKGROUNDS} DESTINATION /usr/share/backgrounds/cuteos)
