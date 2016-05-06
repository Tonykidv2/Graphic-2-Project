#pragma once


struct Material
{

	Material() { ZeroMemory(this, sizeof(this)); }

	XMFLOAT4 Ambient;
	XMFLOAT4 Diffuse;
	XMFLOAT4 Specular; //w = Spec power
	XMFLOAT4 Reflect;
};

struct DirectionalLight
{

	DirectionalLight() { ZeroMemory(this, sizeof(this)); }

	XMFLOAT4 Ambient;
	XMFLOAT4 Diffuse;
	XMFLOAT4 Specular;
	XMFLOAT3 Direction;
	float padding;

};

struct PointLight
{
	PointLight() { ZeroMemory(this, sizeof(this)); }

	XMFLOAT4 Ambient;
	XMFLOAT4 Diffuse;
	XMFLOAT4 Specular;

	//Packed into a 4D vector: (position,range)
	XMFLOAT4 Position;
	float Range;

	//Packed int a 4D vector: (A0, A1, A2, pad)
	XMFLOAT3 Att;
	float pad;

};

struct SpotLight
{
	
	SpotLight() { ZeroMemory(this, sizeof(this)); }

	XMFLOAT4 Ambient;
	XMFLOAT4 Diffuse;
	XMFLOAT4 Specular;

	//Packed into a 4D vector: (position,range)
	XMFLOAT4 Position;
	float Range;

	//Packed into a 4D vector: (direction,spot)
	XMFLOAT3 Direction;
	float Stop;

	//Packed int a 4D vector: (A0, A1, A2, pad)
	XMFLOAT3 Att;
	float pad;

};