#include <SDL3/SDL.h>

int main(int argc, char* argv[]) {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        SDL_Log("Não foi possível inicializar a SDL: %s", SDL_GetError());
        return 1;
    }

    SDL_Window* window = SDL_CreateWindow("Space Invaders - GRUB", 640, 480, 0);
    if (window == nullptr) {
        SDL_Log("Não foi possível criar a janela: %s", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    bool running = true;
    SDL_Event event;
    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_EVENT_QUIT) {
                running = false;
            }
        }
    }

    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}