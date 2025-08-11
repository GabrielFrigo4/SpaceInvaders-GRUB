OUTPUT := ./output
SOURCE := ./source
INCLUDE := ./include
SHADER := ./shader
RESOURCE := ./resource
ASSETS := ./assets

SOURCES_CPP := $(wildcard $(SOURCE)/*.cpp)
SOURCES_C := $(wildcard $(SOURCE)/*.c)

linux:
	mkdir -p $(OUTPUT)
	c++ -std=c++23 -O2 $(SOURCES_CPP) $(SOURCES_C) -I$(INCLUDE) -lSDL3 -o $(OUTPUT)/game

msys2:
	mkdir -p $(OUTPUT)
	c++ -std=c++23 -O2 $(SOURCES_CPP) $(SOURCES_C) -I$(INCLUDE) -lSDL3 -o $(OUTPUT)/game

setup-deb:
	# SDL3
	apt install -y libsdl3-dev
	# OpenGL
	apt install -y libglm-dev
	apt install -y libcglm-dev
	apt install -y libglew-dev
	# OpenAL
	apt install -y libopenal-dev
	# OpenCL
	apt install -y opencl-headers
	apt install -y opencl-clhpp
	apt install -y ocl-icd-opencl-dev
	apt install -y libclc-dev
	# FreeType
	apt install -y libfreetype-dev

setup-arch:
	# SDL3
	pacman --needed --noconfirm -S sdl3
	# OpenGL
	pacman --needed --noconfirm -S glm
	pacman --needed --noconfirm -S cglm
	pacman --needed --noconfirm -S glew
	# OpenAL
	pacman --needed --noconfirm -S openal
	# OpenCL
	pacman --needed --noconfirm -S opencl-headers
	pacman --needed --noconfirm -S opencl-clhpp
	pacman --needed --noconfirm -S opencl-icd-loader
	pacman --needed --noconfirm -S libclc
	# FreeType
	pacman --needed --noconfirm -S freetype2

setup-msys2:
	# SDL3
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sdl3
	# OpenGL
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glm
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cglm
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glew
	# OpenAL
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-openal
	# OpenCL
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-headers
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-clhpp
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-icd
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libclc
	# FreeType
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-freetype

clear:
	rm -r -f $(OUTPUT)
