BIN_DIR      := _bin
OBJ_DIR      := _obj
SOURCE_DIR   := source
INCLUDE_DIR  := include
SHADER_DIR   := shader
RESOURCE_DIR := resource
ASSETS_DIR   := assets

CC           := gcc
CXX          := g++

CFLAGS       := -std=c23 -O2 -fstack-protector-strong -fPIE -flto
CXXFLAGS     := -std=c++23 -O2 -fstack-protector-strong -fPIE -flto
WFLAGS       := -Wformat=2 -Wall -Wextra -Wvla -Wpedantic -Wshadow -Wconversion -Wsign-conversion -Werror -Wno-cpp -Wno-missing-field-initializers -Wno-unknown-warning-option
CPPFLAGS     := -I$(INCLUDE_DIR) -D_DEFAULT_SOURCE -D_POSIX_C_SOURCE=202405L -D_FORTIFY_SOURCE=2
LDFLAGS      := -flto

LIBS_COMMON  := -lSDL3

SOURCES_C    := $(wildcard $(SOURCE_DIR)/*.c)
SOURCES_CPP  := $(wildcard $(SOURCE_DIR)/*.cpp)

UNAME_S      := $(shell uname -s)
IS_WINDOWS   := $(findstring MINGW,$(UNAME_S))$(findstring MSYS,$(UNAME_S))$(filter Windows_NT,$(OS))

ifeq ($(IS_WINDOWS),)
    TARGET_EXT       :=
    LIBS_PLATFORM    := -lGL
    LDFLAGS_PLATFORM := -pie -Wl,-z,relro,-z,now
else
    TARGET_EXT       := .exe
    LIBS_PLATFORM    := -lOPENGL32
    LDFLAGS_PLATFORM := -Wl,--dynamicbase,--nxcompat
endif

LIBS := $(LIBS_COMMON) $(LIBS_PLATFORM)

TARGET_EXE := $(BIN_DIR)/space-invaders$(TARGET_EXT)

.PHONY: all linux msys2 export run clean setup-deb setup-arch setup-msys2

all: $(TARGET_EXE)

linux msys2: all

$(TARGET_EXE): $(SOURCES_CPP) $(SOURCES_C) | $(BIN_DIR)
	@echo "==> Compilando para o alvo '$(UNAME_S)'..."
	@echo "==> Usando bibliotecas: $(LIBS)"
	$(CXX) $(CXXFLAGS) $(WFLAGS) $(CPPFLAGS) $(SOURCES_CPP) $(SOURCES_C) $(LDFLAGS) $(LDFLAGS_PLATFORM) $(LIBS) -o $@
	@echo "==> Executável criado com sucesso em '$@'!"

$(BIN_DIR):
	@echo "==> Criando diretório: $@"
	mkdir -p "$@" "$@/$(SHADER_DIR)" "$@/$(ASSETS_DIR)" 
	cp -r $(SHADER_DIR)/*.frag $@/$(SHADER_DIR)
	cp -r $(SHADER_DIR)/*.vert $@/$(SHADER_DIR)

export: all
	@echo "==> Exportando dependências MSYS2..."
	msys-export.cmd "$(TARGET_EXE)" --dest "$(BIN_DIR)" --msys "ucrt64" --hide

run: all
	@echo "==> Executando o programa..."
	./$(TARGET_EXE)

clean:
	@echo "==> Limpando arquivos de build..."
	rm -rf $(BIN_DIR) $(OBJ_DIR)
	@echo "==> Limpeza concluída."

setup-deb:
	@echo "==> Atualizando repositórios..."
	sudo apt update
	@echo "==> Baixando SDL3..."
	sudo apt install -y \
		libsdl3-dev
	@echo "==> Baixando OpenGL..."
	sudo apt install -y \
		libglm-dev \
		libcglm-dev
	@echo "==> Baixando OpenAL..."
	sudo apt install -y \
		libopenal-dev
	@echo "==> Baixando OpenCL..."
	sudo apt install -y \
		opencl-headers \
		ocl-icd-opencl-dev \
		libclc-19
	@echo "==> Baixando FreeType..."
	sudo apt install -y \
		libfreetype-dev

setup-arch:
	@echo "==> Baixando SDL3..."
	yay --needed --noconfirm -S \
		sdl3
	@echo "==> Baixando OpenGL..."
	yay --needed --noconfirm -S \
		glm \
		cglm
	@echo "==> Baixando OpenAL..."
	yay --needed --noconfirm -S \
		openal
	@echo "==> Baixando OpenCL..."
	yay --needed --noconfirm -S \
		opencl-headers \
		opencl-clhpp \
		opencl-icd-loader \
		libclc
	@echo "==> Baixando FreeType..."
	yay --needed --noconfirm -S \
		freetype2

setup-msys2:
	@echo "==> Baixando SDL3..."
	pacman --needed --noconfirm -S \
		mingw-w64-ucrt-x86_64-sdl3
	@echo "==> Baixando OpenGL..."
	pacman --needed --noconfirm -S \
		mingw-w64-ucrt-x86_64-glm \
		mingw-w64-ucrt-x86_64-cglm
	@echo "==> Baixando OpenAL..."
	pacman --needed --noconfirm -S \
		mingw-w64-ucrt-x86_64-openal
	@echo "==> Baixando OpenCL..."
	pacman --needed --noconfirm -S \
		mingw-w64-ucrt-x86_64-opencl-headers \
		mingw-w64-ucrt-x86_64-opencl-clhpp \
		mingw-w64-ucrt-x86_64-opencl-icd \
		mingw-w64-ucrt-x86_64-libclc
	@echo "==> Baixando FreeType..."
	pacman --needed --noconfirm -S \
		mingw-w64-ucrt-x86_64-freetype
