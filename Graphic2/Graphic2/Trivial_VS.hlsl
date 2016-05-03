#pragma pack_matrix(row_major)

struct INPUT_VERTEX
{
	float4 pos : POSITION;
	//float4 color : COLOR;
	float3 uv : UV;
	float3 normal : NORMALS;
};

struct OUTPUT_VERTEX
{
	//float4 colorOut : COLOR;
	float4 projectedCoordinate : SV_POSITION;
	float3 uvOUT : UV;
	float3 normalOUT: NORMALS;
};

// TODO: PART 3 STEP 2a
cbuffer OBJECT : register(b0)
{
	float4x4 worldMatrix;
	float4x4 viewMatrix;
	float4x4 projectionMatrix;
}

cbuffer TRANSLATOR : register(b1)
{
	float4x4 Rotation;
	float4x4 Translate;
	float Scale;
	float3 padding;
};

OUTPUT_VERTEX main( INPUT_VERTEX fromVertexBuffer )
{
	OUTPUT_VERTEX sendToRasterizer = (OUTPUT_VERTEX)0;
	
	sendToRasterizer.projectedCoordinate.xyz = fromVertexBuffer.pos.xyz;
	sendToRasterizer.projectedCoordinate.w = 1;
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, worldMatrix);
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, viewMatrix);
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, projectionMatrix);
	sendToRasterizer.projectedCoordinate = mul(sendToRasterizer.projectedCoordinate, Translate);
	//sendToRasterizer.colorOut = fromVertexBuffer.color;
	sendToRasterizer.uvOUT = fromVertexBuffer.uv ;
	sendToRasterizer.normalOUT = fromVertexBuffer.normal;

	return sendToRasterizer;
}