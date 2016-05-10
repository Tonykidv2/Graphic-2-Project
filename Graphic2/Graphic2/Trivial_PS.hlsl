#include "LightHelper.hlsli"


struct INPUT_PIXEL
{
	float4 pos : SV_POSITION;
	float3 uv : UV;
	float3 normal : NORMALS;
};

TextureCube TEXTURE : register(t0);
Texture2D Texture1 : register(t1);
SamplerState FILTER : register(s0);

cbuffer texturing : register(b0)
{
	float WhichTexture;
	float3 padding;
}

cbuffer CB_Lights : register(b1)
{
#if USINGOLDLIGHTCODE
	DirectionalLight m_DirLight;
	PointLight m_pointLight;
	SpotLight m_SpotLight;
	Material m_Material;
	float3 m_EyePosw;
	float pad;
#endif

#if !USINGOLDLIGHTCODE
	Lights list[4];
#endif

}


float4 main( INPUT_PIXEL colorFromRasterizer ) : SV_TARGET
{
	
	float4 color;

	if(WhichTexture == 0)
		color = TEXTURE.Sample(FILTER, colorFromRasterizer.normal).rgba;

	if(WhichTexture == 1)
		color = Texture1.Sample(FILTER, colorFromRasterizer.uv).rgba;

	if(WhichTexture == 0)
		return color;

#if !USINGOLDLIGHTCODE

	float4 finalColor = float4(0, 0, 0, 1);

	finalColor.xyz = DirectionalLightCalc(list[0], colorFromRasterizer.normal);
	finalColor.xyz *= color.xyz;
	finalColor.w = color.w;

#endif	

#if USINGOLDLIGHTCODE
	float3 toEyee = normalize(m_EyePosw - colorFromRasterizer.pos);
	
	float4 ambient	= float4(0.0f, 0.0f, 0.0f, 0.0f);
	float4 diffuse	= float4(0.0f, 0.0f, 0.0f, 0.0f);
	float4 spec		= float4(0.0f, 0.0f, 0.0f, 0.0f);
	
	float4 A, D, S;
	
	ComputeDirectionalLight(m_DirLight, color, toEyee, A, D, S);
	
	ambient		+= A;
	diffuse		+= D;
	spec		+= S;
	
	//ComputePointLight(m_pointLight, colorFromRasterizer.pos, (float3)color, toEyee, A, D, S);
	//
	//ambient	+= A;
	//diffuse	+= D;
	//spec		+= S;
	
	//ComputeSpotLight(m_SpotLight, toEyee, (float3)color, toEyee, A, D, S);
	//
	//ambient	+= A;
	//diffuse	+= D;
	//spec		+= S;
	
	float4 litColor = ambient + diffuse + spec; // + color;
	
	litColor.a = m_Material.Diffuse.a; // +color.a;
	litColor = saturate(litColor);

	return litColor;
#endif

	return finalColor;

}