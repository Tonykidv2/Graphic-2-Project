#pragma pack_matrix(row_major)

struct INPUT_VERTEX
{
	float4 pos : POSITION;
	float4 color : COLOR;
};

struct OUTPUT_VERTEX
{
	float4 projectedCoordinate : SV_POSITION;
	float4 colorOut : COLOR;
	//float3 uvOUT : UV;
	//float3 normalOUT: NORMALS;
};

cbuffer OBJECT : register(b0)
{
	float4x4 worldMatrix;
	float4x4 viewMatrix;
	float4x4 projectionMatrix;
};

cbuffer TRANSLATOR : register(b1)
{
	float4x4 Rotation;
	float4x4 Translate;
	float Scale;
	float3 padding;
};

OUTPUT_VERTEX main(INPUT_VERTEX fromVertexBuffer)
{
	OUTPUT_VERTEX sendToRasterizer = (OUTPUT_VERTEX)0;
	
	sendToRasterizer.projectedCoordinate.xyz = fromVertexBuffer.pos.xyz;
	sendToRasterizer.projectedCoordinate.w = 1;
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, worldMatrix);
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, viewMatrix);
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, projectionMatrix);
	sendToRasterizer.colorOut = fromVertexBuffer.color;
	return sendToRasterizer;
}