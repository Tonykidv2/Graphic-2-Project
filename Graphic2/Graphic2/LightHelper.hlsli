#pragma pack_matrix(row_major)
#define USINGOLDLIGHTCODE FALSE

struct DirectionalLight
{
	float4 Ambient;
	float4 Diffuse;
	float4 Specular;
	float3 Direction;
	float padding;
};

struct PointLight
{
	float4 Ambient;
	float4 Diffuse;
	float4 Specular;

	float3 Position;
	float Range;

	float3 Att;
	float padding;
};

struct SpotLight
{
	float4 Ambient;
	float4 Diffuse;
	float4 Specular;

	float3 Position;
	float Range;

	float3 Direction;
	float Spot;

	float3 Att;
	float padding;
};

struct Material
{
	float4 Ambient;
	float4 Diffuse;
	float4 Specular; //w = Spec power
	float4 Reflect;
};

void ComputeDirectionalLight(DirectionalLight Light, float3 Normal, float3 toEye,
	out float4 ambient,
	out float4 diffuse,
	out float4 spec)
{
	//initailize outputs
	ambient = float4(0.0f, 0.0f, 0.0f, 0.0f);
	diffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);
	spec = float4(0.0f, 0.0f, 0.0f, 0.0f);

	//the light vector aims opposite of the light ------ Light><surface
	float3 lightVec = -Light.Direction;

	//adding ambient term
	ambient = /*mat.Ambient*/ float4(Normal, 1) *  Light.Ambient;

	//adding diffuse and specular terms assuming the surfase is line of site from light.
	float diffuseFactor = dot(lightVec, Normal);

	//Flatten to avoid Dynamic branching branching will ask questions what this is
	[flatten]
	if (diffuseFactor > 0.0f)
	{

		float3 vec			= reflect(-lightVec, Normal);
		float specFactor	= pow(max(dot(vec, toEye), 0.0f), /*mat.Specular.w*/ 1);

		diffuse = diffuseFactor * /*mat.Diffuse*/ float4(Normal,1) * Light.Diffuse;
		spec = specFactor * /*mat.Specular*/ float4(Normal,1) * Light.Specular;
	}
}

void ComputePointLight(PointLight Light, float3 pos, float3 Normal, float3 toEye,
	out float4 ambient,
	out float4 diffuse,
	out float4 spec)
{

	//initailize outputs
	ambient = float4(0.0f, 0.0f, 0.0f, 0.0f);
	diffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);
	spec	= float4(0.0f, 0.0f, 0.0f, 0.0f);

	//Finding the vector from the surface to the light
	float3 LightVec = Light.Position - pos;

	//Finding distance from surface to light
	float distance = length(LightVec);

	//Is is too far away
	if (distance > Light.Range)
		return;

	//Normalizing the light bro then
	LightVec /= distance;

	//adding ambient term
	ambient = float4(Normal, 1) * Light.Ambient;

	//adding diffuse and specular terms assuming the surfase is line of site from light.
	float diffuseFactor = dot(LightVec, Normal);

	//Flatten to avoid Dynamic branching branching will ask questions what this is
	[flatten]
	if (diffuseFactor > 0.0f)
	{

		float3 vec = reflect(-LightVec, Normal);
		float specFactor = pow(max(dot(vec, toEye), 0.0f), /*mat.Specular.w*/ 1);

		diffuse = diffuseFactor * /*mat.Diffuse*/ float4(Normal, 1) * Light.Diffuse;
		spec = specFactor * /*mat.Specular*/ float4(Normal, 1) * Light.Specular;
	}

	// Attenuate
	float att = 1.0f / dot(Light.Att, float3(1.0f, distance, distance*distance));

	diffuse *= att;
	spec *= att;
}

void ComputeSpotLight(SpotLight Light, float3 pos, float3 Normal, float3 toEye,
	out float4 ambient,
	out float4 diffuse,
	out float4 spec)
{

	//initailize outputs
	ambient = float4(0.0f, 0.0f, 0.0f, 0.0f);
	diffuse = float4(0.0f, 0.0f, 0.0f, 0.0f);
	spec = float4(0.0f, 0.0f, 0.0f, 0.0f);

	//Finding the vector from the surface to the light
	float3 LightVec = Light.Position - pos;

	//Finding distance from surface to light
	float distance = length(LightVec);

	//Is is too far away
	if (distance > Light.Range)
		return;

	//Normalizing the light bro then
	LightVec /= distance;

	//adding ambient term
	ambient = /*mat.Ambient*/ float4(Normal, 1) * Light.Ambient;

	//adding diffuse and specular terms assuming the surfase is line of site from light.
	float diffuseFactor = dot(LightVec, Normal);

	//Flatten to avoid Dynamic branching branching will ask questions what this is
	[flatten]
	if (diffuseFactor > 0.0f)
	{

		float3 vec = reflect(-LightVec, Normal);
		float specFactor = pow(max(dot(vec, toEye), 0.0f), /*mat.Specular.w*/ 1);

		diffuse = diffuseFactor * /*mat.Diffuse*/ float4(Normal, 1) * Light.Diffuse;
		spec = specFactor * /*mat.Specular*/ float4(Normal, 1) * Light.Specular;
	}

	//Scale by SpotLight factor then attenuate
	float spot = pow(max(dot(-LightVec, Light.Direction), 0.0f), Light.Spot);
	float att = spot / dot(Light.Att, float3(1.0f, distance, distance*distance));

	ambient *= spot;
	diffuse *= att;
	spec	*= att;

}


struct Lights
{

	//w = (AMB, DIR, PNT, SPT)
	
	//Spot light does use position
	//Directional use position
	//stop do use lights
	float4 Position;
	//ambient light does not use direction
	//Directional light Direction
	float4 Direction;
	//color
	float4 Color;
	//misc data for light
	float4 radius;
};


float3 DirectionalLightCalc(Lights light, float3 surface_normal)
{
	float dirLightRatio = saturate(dot(-normalize(light.Direction), normalize(surface_normal)));

	return light.Color.xyz * dirLightRatio;
}

//float3 PNTLightCalc(Lights light, )