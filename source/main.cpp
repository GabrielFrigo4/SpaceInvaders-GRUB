#include <SDL3/SDL.h>
#include <GL/glew.h>
#include "logging.hpp"
#include "render.hpp"

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;

int main(void)
{
	if (!SDL_Init(SDL_INIT_VIDEO))
	{
		LOG_ERRO("Não foi possível inicializar o SDL3: %s", SDL_GetError());
		return 1;
	}

	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

	SDL_Window *window = SDL_CreateWindow("Space Invaders - GRUB",
										  WINDOW_WIDTH,
										  WINDOW_HEIGHT,
										  SDL_WINDOW_OPENGL);
	if (window == nullptr)
	{
		LOG_ERRO("Não foi possível criar a janela: %s", SDL_GetError());
		SDL_Quit();
		return 1;
	}

	SDL_GLContext context = SDL_GL_CreateContext(window);
	if (context == nullptr)
	{
		LOG_ERRO("Não foi possível criar o contexto OpenGL: %s", SDL_GetError());
		SDL_DestroyWindow(window);
		SDL_Quit();
		return 1;
	}

	glewExperimental = GL_TRUE;
	GLenum glew_status = glewInit();
	if (glew_status != GLEW_OK)
	{
		LOG_ERRO("Não foi possível inicializar GLEW: %s", glewGetErrorString(glew_status));
		SDL_GL_DestroyContext(context);
		SDL_DestroyWindow(window);
		SDL_Quit();
		return 1;
	}
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	LOG_INFO("OpenGL version: %s", glGetString(GL_VERSION));
	LOG_INFO("GLEW version: %s", glewGetString(GLEW_VERSION));
	if (!render_init(window))
	{
		SDL_Log(ERRO("Não foi possível inicializar o render"));
		return 1;
	}

	bool running = true;
	SDL_Event event;
	while (running)
	{
		while (SDL_PollEvent(&event))
		{
			if (event.type == SDL_EVENT_QUIT)
			{
				running = false;
			}
		}

		glClearColor(0.16f, 0.16f, 0.16f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);

		render_rectangle(1.0f, 0.0f, 0.0f, 1.0f, 300, 250, 500, 450);
		render_rectangle(0.0f, 1.0f, 0.0f, 1.0f, 200, 150, 400, 350);
		render_rectangle(0.0f, 0.0f, 1.0f, 1.0f, 100, 050, 300, 250);

		render_rectangle(0.5f, 0.5f, 0.5f, 0.25f, 350, 250, 450, 450);
		render_rectangle(0.5f, 0.5f, 0.5f, 0.25f, 250, 150, 350, 350);
		render_rectangle(0.5f, 0.5f, 0.5f, 0.25f, 150, 050, 250, 250);

		SDL_GL_SwapWindow(window);
	}

	SDL_GL_DestroyContext(context);
	SDL_DestroyWindow(window);
	SDL_Quit();

	return 0;
}
