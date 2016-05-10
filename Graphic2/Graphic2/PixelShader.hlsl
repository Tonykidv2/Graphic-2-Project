#include "LightHelper.hlsli"

struct INPUT_PIXEL
{
	float4 pos : SV_POSITION;
	float4 color : COLOR;
	float3 normal : NORMALS;
};

cbuffer CB_Lights : register(b1)
{
	Lights list[4];
}

float4 main(INPUT_PIXEL colorFromRasterizer) : SV_TARGET
{
	float4 finalColor = float4(0, 0, 0, 1);

	finalColor.xyz = DirectionalLightCalc(list[0], colorFromRasterizer.normal);
	finalColor.xyz += colorFromRasterizer.color.xyz;
	finalColor.w = colorFromRasterizer.color.w;

	return finalColor;
}