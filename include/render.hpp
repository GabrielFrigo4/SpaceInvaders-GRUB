#ifndef RENDER_HPP
#define RENDER_HPP
#endif

#include <SDL3/SDL.h>

bool render_init(SDL_Window *window);
void render_rectangle(float r, float g, float b, float a, float x1, float y1, float x2, float y2);
