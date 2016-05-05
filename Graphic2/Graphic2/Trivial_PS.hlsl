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

float4 main( INPUT_PIXEL colorFromRasterizer ) : SV_TARGET
{
	
	if(WhichTexture == 0)
		return TEXTURE.Sample(FILTER, colorFromRasterizer.normal).rgba;

	if(WhichTexture == 1)
		return Texture1.Sample(FILTER, colorFromRasterizer.uv).rgba;


	return float4(1.0f, 1.0f, 1.0f, 1.0f);
}