linux:
	mkdir -p ./output
	c++ ./source/*.cpp -I./include/ -lSDL3 -o ./output/game

msys2:
	mkdir -p ./output
	c++ ./source/*.cpp -I./include/ -lSDL3 -o ./output/game

setup-deb:
	apt install -y libsdl3-dev
	apt install -y libopenal-dev

setup-arch:
	pacman --needed --noconfirm -S sdl3
	pacman --needed --noconfirm -S openal

setup-msys2:
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sdl3
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-openal

clear:
	rm -r -f ./output
