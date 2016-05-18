struct INPUT_PS
{
	float4 vPosition  : SV_POSITION;
	float3 wPositon : WorldPOS;
	float3 norm : NORMAL;
	float3 uv : UV;
	// TODO: change/add other stuff
};


float4 main(INPUT_PS input) : SV_TARGET
{
	return float4(1.0f, 1.0f, 1.0f, 1.0f);
}