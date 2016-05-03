struct INPUT_PIXEL
{
	float4 pos : SV_POSITION;
	//float4 color : COLOR;
	float3 uv : UV;
	float3 normal : NORMALS;
};

texture2D TEXTURE : register(t0);
SamplerState FILTER : register(s0);

cbuffer texturing : register(b0)
{
	float WhichTexture;
	float3 padding;
}

float4 main( INPUT_PIXEL colorFromRasterizer ) : SV_TARGET
{
	float2 uv = colorFromRasterizer.uv.xy;
	
	uv[0] = uv[0] * .25f + WhichTexture;
	
	return TEXTURE.Sample(FILTER, uv).grab;
}