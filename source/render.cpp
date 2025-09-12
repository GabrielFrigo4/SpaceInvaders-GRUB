#include <SDL3/SDL.h>
#include <glad/gl.h>
#include "logging.hpp"
#include "render.hpp"

#include <algorithm>
#include <fstream>
#include <sstream>
#include <string>

std::string read_shader_file(const char *file_path)
{
	std::ifstream shader_file(file_path);
	if (!shader_file.is_open())
	{
		LOG_ERRO("Não foi possivel abrir o arquivo: %s", file_path);
		return "";
	}
	std::stringstream shader_stream;
	shader_stream << shader_file.rdbuf();
	shader_file.close();
	return shader_stream.str();
}

SDL_Window *sdl_window = nullptr;
GLuint polygon_shader_program = 0;
GLuint triangle_vao = 0;
GLuint triangle_vbo = 0;
GLuint rectangle_vao = 0;
GLuint rectangle_vbo = 0;

bool render_init(SDL_Window *window)
{
	sdl_window = window;

	std::string vertex_shader_src = read_shader_file("shader/polygon.vert");
	std::string fragment_shader_src = read_shader_file("shader/polygon.frag");

	if (vertex_shader_src.empty() || fragment_shader_src.empty())
	{
		LOG_ERRO("Falha ao ler os arquivos de shader. Verifique o caminho.");
		return false;
	}

	const int log_len = 512;
	char log_info[log_len];
	const char *vertex_shader_code = vertex_shader_src.c_str();
	const char *fragment_shader_code = fragment_shader_src.c_str();

	GLuint vertex_shader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertex_shader, 1, &vertex_shader_code, NULL);
	glCompileShader(vertex_shader);
	int success;
	glGetShaderiv(vertex_shader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(vertex_shader, log_len, NULL, log_info);
		LOG_ERRO("COMPILÇÃO FALHOU (Vertex Shader):\n%s", log_info);
		return false;
	}
	LOG_INFO("vertex_shader criado com ID: %u", vertex_shader);

	GLuint fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragment_shader, 1, &fragment_shader_code, NULL);
	glCompileShader(fragment_shader);
	glGetShaderiv(fragment_shader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(fragment_shader, log_len, NULL, log_info);
		LOG_ERRO("COMPILÇÃO FALHOU (Fragment Shader):\n%s", log_info);
		return false;
	}
	LOG_INFO("fragment_shader criado com ID: %u", fragment_shader);

	polygon_shader_program = glCreateProgram();
	glAttachShader(polygon_shader_program, vertex_shader);
	glAttachShader(polygon_shader_program, fragment_shader);
	glLinkProgram(polygon_shader_program);
	glGetProgramiv(polygon_shader_program, GL_LINK_STATUS, &success);
	if (!success)
	{
		glGetProgramInfoLog(polygon_shader_program, log_len, NULL, log_info);
		LOG_ERRO("LINKAGEM FALHOU (Shader Program):\n%s", log_info);
		return false;
	}
	glDeleteShader(vertex_shader);
	glDeleteShader(fragment_shader);
	LOG_INFO("polygon_shader_program criado com ID: %u", polygon_shader_program);

	glGenVertexArrays(1, &rectangle_vao);
	glGenBuffers(1, &rectangle_vbo);
	LOG_INFO("rectangle_vao criado com ID: %u", rectangle_vao);
	LOG_INFO("rectangle_vbo criado com ID: %u", rectangle_vbo);

	glBindVertexArray(rectangle_vao);
	glBindBuffer(GL_ARRAY_BUFFER, rectangle_vbo);
	glBufferData(GL_ARRAY_BUFFER, 6 * sizeof(float) * 2, NULL, GL_DYNAMIC_DRAW);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void *)0);
	glEnableVertexAttribArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	glGenVertexArrays(1, &triangle_vao);
	glGenBuffers(1, &triangle_vbo);
	LOG_INFO("triangle_vao criado com ID: %u", triangle_vao);
	LOG_INFO("triangle_vbo criado com ID: %u", triangle_vbo);

	glBindVertexArray(triangle_vao);
	glBindBuffer(GL_ARRAY_BUFFER, triangle_vbo);
	glBufferData(GL_ARRAY_BUFFER, 3 * sizeof(float) * 2, NULL, GL_DYNAMIC_DRAW);
	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), (void *)0);
	glEnableVertexAttribArray(0);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	LOG_INFO("Render init concluido com sucesso.");
	return true;
}

void render_triangle(float r, float g, float b, float a, float x1, float y1, float x2, float y2, float x3, float y3)
{
	if (polygon_shader_program == 0 || triangle_vao == 0 || triangle_vbo == 0)
	{
		LOG_ERRO("Tentando desenhar com objetos OpenGL invalidos! IDs -> shader: %u, triangle_vao: %u, triangle_vbo: %u", polygon_shader_program, triangle_vao, triangle_vbo);
		exit(1);
	}

	int width, height;
	SDL_GetWindowSize(sdl_window, &width, &height);

	glUseProgram(polygon_shader_program);

	float projection[4][4] = {
		{2.0f / width, 0.0f, 0.0f, -1.0f},
		{0.0f, 2.0f / height, 0.0f, -1.0f},
		{0.0f, 0.0f, 0.0f, 0.0f},
		{0.0f, 0.0f, 0.0f, 1.0f}};
	projection[1][1] *= -1.0f;
	projection[1][3] *= -1.0f;

	glUniformMatrix4fv(glGetUniformLocation(polygon_shader_program, "projection"), 1, GL_TRUE, &projection[0][0]);
	glUniform4f(glGetUniformLocation(polygon_shader_program, "rectangleColor"), r, g, b, a);

	float vertices[] = {
		x1, y1,
		x2, y2,
		x3, y3};

	glBindBuffer(GL_ARRAY_BUFFER, triangle_vbo);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	glBindVertexArray(triangle_vao);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);
}

void render_rectangle(float r, float g, float b, float a, float x1, float y1, float x2, float y2)
{
	if (polygon_shader_program == 0 || rectangle_vao == 0 || rectangle_vbo == 0)
	{
		LOG_ERRO("Tentando desenhar com objetos OpenGL invalidos! IDs -> shader: %u, rectangle_vao: %u, rectangle_vbo: %u", polygon_shader_program, rectangle_vao, rectangle_vbo);
		exit(1);
	}

	int width, height;
	SDL_GetWindowSize(sdl_window, &width, &height);

	glUseProgram(polygon_shader_program);

	float projection[4][4] = {
		{2.0f / width, 0.0f, 0.0f, -1.0f},
		{0.0f, 2.0f / height, 0.0f, -1.0f},
		{0.0f, 0.0f, 0.0f, 0.0f},
		{0.0f, 0.0f, 0.0f, 1.0f}};
	projection[1][1] *= -1.0f;
	projection[1][3] *= -1.0f;

	glUniformMatrix4fv(glGetUniformLocation(polygon_shader_program, "projection"), 1, GL_TRUE, &projection[0][0]);
	glUniform4f(glGetUniformLocation(polygon_shader_program, "rectangleColor"), r, g, b, a);

	float vertices[] = {
		x1, y1, x2, y2, x2, y1,
		x1, y1, x1, y2, x2, y2};

	glBindBuffer(GL_ARRAY_BUFFER, rectangle_vbo);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	glBindVertexArray(rectangle_vao);
	glDrawArrays(GL_TRIANGLES, 0, 6);
	glBindVertexArray(0);
}
