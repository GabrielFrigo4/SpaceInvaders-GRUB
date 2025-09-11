# --- Configuração do Projeto ---
BIN_DIR := _bin
OBJ_DIR := _obj

SOURCE_DIR := source
INCLUDE_DIR := include
SHADER_DIR := shader
RESOURCE_DIR := resource
ASSETS_DIR := assets

TARGET_EXE := $(BIN_DIR)/space-invaders

# --- Configuração do Compilador e Flags ---
CC := gcc
CCFLAGS := -std=c23 -O2 -I$(INCLUDE_DIR) -Wall -Wextra

CPP := g++
CPPFLAGS := -std=c++23 -O2 -I$(INCLUDE_DIR) -Wall -Wextra

# --- Detecção Automática de Arquivos ---
SOURCES_C := $(wildcard $(SOURCE_DIR)/*.c)
SOURCES_CPP := $(wildcard $(SOURCE_DIR)/*.cpp)

# --- Configuração do Linker ---
LIBS_LINUX := -lsdl3 -lglew -lgl
LIBS_MSYS2 := -lsdl3 -lglew32 -lopengl32

# --- Regras (Targets) ---
.PHONY: all
all: linux

.PHONY: linux msys2
linux: LIBS = $(LIBS_LINUX)
msys2: LIBS = $(LIBS_MSYS2)
linux msys2: $(TARGET_EXE)

$(TARGET_EXE): $(SOURCES_CPP) | $(BIN_DIR)
	@echo "==> Compilando para o alvo '$(MAKECMDGOALS)'..."
	@echo "==> Usando bibliotecas: $(LIBS)"
	$(CPP) $(CPPFLAGS) $(SOURCES_CPP) $(LIBS) -o $@
	@echo "==> Executável criado com sucesso em '$@'!"

$(BIN_DIR):
	@echo "==> Criando diretório: $@"
	mkdir -p "$@" "$@/$(SHADER_DIR)" "$@/$(ASSETS_DIR)" 
	cp -r $(SHADER_DIR)/*.frag $@/$(SHADER_DIR)
	cp -r $(SHADER_DIR)/*.vert $@/$(SHADER_DIR)
#	cp -r $(ASSETS_DIR)/*.wav $@/$(ASSETS_DIR)
#	cp -r $(ASSETS_DIR)/*.png $@/$(ASSETS_DIR)

# --- Regras Utilitárias ---
.PHONY: export
export: all
	@echo "==> Exportando dependências MSYS2..."
	msys-export.cmd "$(TARGET_EXE).exe" --dest "$(BIN_DIR)" --msys "ucrt64" --hide

.PHONY: run
run: all
	@echo "==> Executando o programa..."
	./$(TARGET_EXE)

.PHONY: clean
clean:
	@echo "==> Limpando arquivos de build..."
	rm -rf $(BIN_DIR) $(OBJ_DIR)
	@echo "==> Limpeza concluída."

# --- Regras Bibliotecas ---
.PHONY: setup-deb
setup-deb:
	@echo "==> Baixando SDL3..."
	sudo apt install -y libsdl3-dev
	@echo "==> Baixando OpenGL..."
	sudo apt install -y libglm-dev
	sudo apt install -y libcglm-dev
	sudo apt install -y libglew-dev
	@echo "==> Baixando OpenAL..."
	sudo apt install -y libopenal-dev
	@echo "==> Baixando OpenCL..."
	sudo apt install -y opencl-headers
	sudo apt install -y ocl-icd-opencl-dev
	sudo apt install -y libclc-19
	@echo "==> Baixando FreeType..."
	sudo apt install -y libfreetype-dev

.PHONY: setup-arch
setup-arch:
	@echo "==> Baixando SDL3..."
	yay --needed --noconfirm -S sdl3
	@echo "==> Baixando OpenGL..."
	yay --needed --noconfirm -S glm
	yay --needed --noconfirm -S cglm
	yay --needed --noconfirm -S glew
	@echo "==> Baixando OpenAL..."
	yay --needed --noconfirm -S openal
	@echo "==> Baixando OpenCL..."
	yay --needed --noconfirm -S opencl-headers
	yay --needed --noconfirm -S opencl-clhpp
	yay --needed --noconfirm -S opencl-icd-loader
	yay --needed --noconfirm -S libclc
	@echo "==> Baixando FreeType..."
	yay --needed --noconfirm -S freetype2

.PHONY: setup-msys2
setup-msys2:
	@echo "==> Baixando SDL3..."
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-sdl3
	@echo "==> Baixando OpenGL..."
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glm
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-cglm
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-glew
	@echo "==> Baixando OpenAL..."
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-openal
	@echo "==> Baixando OpenCL..."
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-headers
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-clhpp
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-opencl-icd
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-libclc
	@echo "==> Baixando FreeType..."
	pacman --needed --noconfirm -S mingw-w64-ucrt-x86_64-freetype
