#ifndef LOGGING_HPP
#define LOGGING_HPP
#define INFO(msg) "[INFO]: " msg
#define WARN(msg) "[WARN]: " msg
#define ERRO(msg) "[ERRO]: " msg
#define LOG_INFO(...) SDL_Log("[INFO]: " __VA_ARGS__)
#define LOG_WARN(...) SDL_Log("[WARN]: " __VA_ARGS__)
#define LOG_ERRO(...) SDL_Log("[ERRO]: " __VA_ARGS__)
#endif

#include <SDL3/SDL.h>
