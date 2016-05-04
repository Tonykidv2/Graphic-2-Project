#pragma once

#include <iostream>
#include <ctime>
#include <math.h>
#include <Windows.h>
#include <DirectXMath.h>
#include "Load Model.h"

using namespace DirectX;
using namespace std;

#define RASTER_WIDTH 500.0f
#define RASTER_HEIGHT 500.0f
#define NUM_PIXEL UINT(RASTER_WIDTH * RASTER_HEIGHT)
#define M_PI 3.14159

unsigned int Raster[NUM_PIXEL];
float Zbuffer[NUM_PIXEL];

#define FIELDOFVIEW 65.0f
#define ASPECTRATIO ((RASTER_WIDTH) / (RASTER_HEIGHT))
#define ZNEAR 0.1f
#define ZFAR 100.0f


struct SEND_TO_VRAM_WORLD
{
	XMMATRIX worldMatrix;
	XMMATRIX viewMatrix;
	XMMATRIX projectView;
};

struct SEND_TO_VRAM_PIXEL
{
	float whichTexture;
	XMFLOAT3 padding;
};

struct TRANSLATOR
{
	XMMATRIX Rotation;
	XMMATRIX Translate;
	float Scale;
	XMFLOAT3 padding;
};

struct VERTEX
{
	XMFLOAT4 XYZW;
	XMFLOAT3 UV;
	XMFLOAT3 normals;
};

struct SIMPLE_VERTEX
{
	XMFLOAT4 XYZW;
	XMFLOAT4 RGBA;
};