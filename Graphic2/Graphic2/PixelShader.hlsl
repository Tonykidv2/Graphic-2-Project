struct INPUT_PIXEL
{
	float4 pos : SV_POSITION;
	float4 color : COLOR;
};


float4 main(INPUT_PIXEL colorFromRasterizer) : SV_TARGET
{
	return colorFromRasterizer.color;
}