
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


void ComputeDirectionalLight(Material mat, DirectionalLight Light, float3 Normal, float3 toEye,
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
	ambient = mat.Ambient * Light.Ambient;

	//adding diffuse and specular terms assuming the surfase is line of site from light.
	float diffuseFactor = dot(lightVec, Normal);

	//Flatten to avoid Dynamic branching branching will ask questions what this is
	[flatten]
	if (diffuseFactor > 0.0f)
	{

		float3 vec			= reflect(-lightVec, Normal);
		float specFactor	= pow(max(dot(vec, toEye), 0.0f), mat.Specular.w);

		diffuse = diffuseFactor * mat.Diffuse * Light.Diffuse;
		spec = specFactor * mat.Specular * Light.Specular;
	}
}

void ComputePointLight(Material mat, PointLight Light, float3 pos, float3 Normal, float3 toEye,
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
	ambient = mat.Ambient * Light.Ambient;

	//adding diffuse and specular terms assuming the surfase is line of site from light.
	float diffuseFactor = dot(LightVec, Normal);

	//Flatten to avoid Dynamic branching branching will ask questions what this is
	[flatten]
	if (diffuseFactor > 0.0f)
	{

		float3 vec = reflect(-LightVec, Normal);
		float specFactor = pow(max(dot(vec, toEye), 0.0f), mat.Specular.w);

		diffuse = diffuseFactor * mat.Diffuse * Light.Diffuse;
		spec = specFactor * mat.Specular * Light.Specular;
	}

	// Attenuate
	float att = 1.0f / dot(Light.Att, float3(1.0f, distance, distance*distance));

	diffuse *= att;
	spec *= att;
}

void ComputeSpotLight(Material mat, SpotLight Light, float3 pos, float3 Normal, float3 toEye,
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
	ambient = mat.Ambient * Light.Ambient;

	//adding diffuse and specular terms assuming the surfase is line of site from light.
	float diffuseFactor = dot(LightVec, Normal);

	//Flatten to avoid Dynamic branching branching will ask questions what this is
	[flatten]
	if (diffuseFactor > 0.0f)
	{

		float3 vec = reflect(-LightVec, Normal);
		float specFactor = pow(max(dot(vec, toEye), 0.0f), mat.Specular.w);

		diffuse = diffuseFactor * mat.Diffuse * Light.Diffuse;
		spec = specFactor * mat.Specular * Light.Specular;
	}

	//Scale by SpotLight factor then attenuate
	float spot = pow(max(dot(-LightVec, Light.Direction), 0.0f), Light.Spot);
	float att = spot / dot(Light.Att, float3(1.0f, distance, distance*distance));

	ambient *= spot;
	diffuse *= att;
	spec	*= att;

}