linux:
	c++ ./source/*.cpp -I./include/ -o game

msys2:
	c++ ./source/*.cpp -I./include/ -o game

setup-deb:
	apt install sdl3 openal opencl

setup-arch:
	pacman -S sdl3 openal opencl

setup-msys2:
	pacman -S sdl3 openal opencl
