#if 0
//
// Generated by Microsoft (R) HLSL Shader Compiler 6.3.9600.16384
//
//
// Buffer Definitions: 
//
// cbuffer texturing
// {
//
//   float WhichTexture;                // Offset:    0 Size:     4
//   float3 padding;                    // Offset:    4 Size:    12 [unused]
//
// }
//
// cbuffer CB_Lights
// {
//
//   struct Lights
//   {
//       
//       float4 Position;               // Offset:    0
//       float4 Direction;              // Offset:   16
//       float4 Color;                  // Offset:   32
//       float4 radius;                 // Offset:   48
//
//   } list[4];                         // Offset:    0 Size:   256
//
// }
//
//
// Resource Bindings:
//
// Name                                 Type  Format         Dim Slot Elements
// ------------------------------ ---------- ------- ----------- ---- --------
// FILTER                            sampler      NA          NA    0        1
// TEXTURE                           texture  float4        cube    0        1
// Texture1                          texture  float4          2d    1        1
// TextureNorm                       texture  float4          2d    2        1
// texturing                         cbuffer      NA          NA    0        1
// CB_Lights                         cbuffer      NA          NA    1        1
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_POSITION              0   xyzw        0      POS   float       
// UV                       0   xyz         1     NONE   float   xy  
// NORMALS                  0   xyz         2     NONE   float   xyz 
// POSITIONW                0   xyz         3     NONE   float   xyz 
// TANGENT                  0   xyz         4     NONE   float   xyz 
// BITANGENT                0   xyz         5     NONE   float       
// TEXCOORD                 1   xy          6     NONE   float       
// TEXCOORD                 2     zw        6     NONE   float       
// TEXCOORD                 3   xy          7     NONE   float       
// TEXCOORD                 4     zw        7     NONE   float       
// TEXCOORD                 5   xy          8     NONE   float       
// TEXCOORD                 6     zw        8     NONE   float       
// TEXCOORD                 7   xy          9     NONE   float       
// TEXCOORD                 8     zw        9     NONE   float       
// TEXCOORD                 9   xy         10     NONE   float       
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue  Format   Used
// -------------------- ----- ------ -------- -------- ------- ------
// SV_TARGET                0   xyzw        0   TARGET   float   xyzw
//
ps_5_0
dcl_globalFlags refactoringAllowed
dcl_constantbuffer cb0[1], immediateIndexed
dcl_constantbuffer cb1[12], immediateIndexed
dcl_sampler s0, mode_default
dcl_resource_texturecube (float,float,float,float) t0
dcl_resource_texture2d (float,float,float,float) t1
dcl_resource_texture2d (float,float,float,float) t2
dcl_input_ps linear v1.xy
dcl_input_ps linear v2.xyz
dcl_input_ps linear v3.xyz
dcl_input_ps linear v4.xyz
dcl_output o0.xyzw
dcl_temps 5
eq r0.x, cb0[0].x, l(0.000000)
if_nz r0.x
  sample_indexable(texturecube)(float,float,float,float) o0.xyzw, v2.xyzx, t0.xyzw, s0
  ret 
endif 
eq r0.xy, cb0[0].xxxx, l(1.000000, 2.000000, 0.000000, 0.000000)
if_nz r0.x
  sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v1.xyxx, t1.xyzw, s0
  sample_indexable(texture2d)(float,float,float,float) r0.xzw, v1.xyxx, t2.xwyz, s0
  mov o0.w, r1.w
else 
  mov r1.xyz, l(0,0,0,0)
  mov r0.xzw, l(0,0,0,0)
  mov o0.w, l(1.000000)
endif 
mad r0.xzw, r0.xxzw, l(2.000000, 0.000000, 2.000000, 2.000000), l(-1.000000, 0.000000, -1.000000, -1.000000)
dp3 r2.x, v2.xyzx, v2.xyzx
rsq r2.x, r2.x
mul r2.xyz, r2.xxxx, v2.xyzx
dp3 r2.w, v4.xyzx, v4.xyzx
rsq r2.w, r2.w
mul r3.xyz, r2.wwww, v4.xyzx
mul r4.xyz, r2.zxyz, r3.yzxy
mad r4.xyz, r2.yzxy, r3.zxyz, -r4.xyzx
dp3 r2.w, r4.xyzx, r4.xyzx
rsq r2.w, r2.w
mul r4.xyz, r2.wwww, r4.xyzx
mul r4.xyz, r0.zzzz, r4.xyzx
mad r3.xyz, r0.xxxx, r3.xyzx, r4.xyzx
mad r0.xzw, r0.wwww, r2.xxyz, r3.xxyz
if_nz r0.y
  sample_indexable(texture2d)(float,float,float,float) r1.xyzw, v1.xyxx, t1.xyzw, s0
  mov o0.w, r1.w
endif 
movc r0.xyz, r0.yyyy, v2.xyzx, r0.xzwx
eq r0.w, cb1[3].x, l(1.000000)
dp4 r1.w, cb1[1].xyzw, cb1[1].xyzw
rsq r1.w, r1.w
mul r2.xyz, r1.wwww, cb1[1].xyzx
dp3 r1.w, r0.xyzx, r0.xyzx
rsq r1.w, r1.w
mul r0.xyz, r0.xyzx, r1.wwww
dp3_sat r1.w, -r2.xyzx, r0.xyzx
mul r2.xyz, r1.wwww, cb1[2].xyzx
and r2.xyz, r0.wwww, r2.xyzx
eq r0.w, cb1[7].x, l(1.000000)
add r3.xyz, -v3.xyzx, cb1[4].xyzx
dp3 r1.w, r3.xyzx, r3.xyzx
rsq r2.w, r1.w
mul r3.xyz, r2.wwww, r3.xyzx
dp3_sat r2.w, r3.xyzx, r0.xyzx
sqrt r1.w, r1.w
div_sat r1.w, r1.w, cb1[7].w
add r1.w, -r1.w, l(1.000000)
mul r3.xyz, r2.wwww, cb1[6].xyzx
mad r3.xyz, r3.xyzx, r1.wwww, r2.xyzx
movc r2.xyz, r0.wwww, r3.xyzx, r2.xyzx
eq r0.w, cb1[11].x, l(1.000000)
add r3.xyz, -v3.xyzx, cb1[8].xyzx
dp3 r1.w, r3.xyzx, r3.xyzx
rsq r1.w, r1.w
mul r3.xyz, r1.wwww, r3.xyzx
dp3_sat r1.w, -r3.xyzx, cb1[9].xyzx
lt r2.w, cb1[11].w, r1.w
and r2.w, r2.w, l(0x3f800000)
dp3_sat r0.x, r3.xyzx, r0.xyzx
add r0.y, -r1.w, cb1[11].y
add r0.z, -cb1[11].z, cb1[11].y
div_sat r0.y, r0.y, r0.z
add r0.y, -r0.y, l(1.000000)
mul r0.x, r0.x, r2.w
mul r3.xyz, r0.xxxx, cb1[10].xyzx
mul r0.x, r0.y, r0.y
mad r0.xyz, r0.xxxx, r3.xyzx, r2.xyzx
movc r0.xyz, r0.wwww, r0.xyzx, r2.xyzx
mul o0.xyz, r1.xyzx, r0.xyzx
ret 
// Approximately 77 instruction slots used
#endif

const BYTE Trivial_PS[] =
{
     68,  88,  66,  67, 204, 160, 
    223, 136, 240, 105,  70, 228, 
    201, 106,  50, 184,  63, 156, 
     98,  42,   1,   0,   0,   0, 
     20,  15,   0,   0,   5,   0, 
      0,   0,  52,   0,   0,   0, 
    100,   3,   0,   0,  24,   5, 
      0,   0,  76,   5,   0,   0, 
    120,  14,   0,   0,  82,  68, 
     69,  70,  40,   3,   0,   0, 
      2,   0,   0,   0,  52,   1, 
      0,   0,   6,   0,   0,   0, 
     60,   0,   0,   0,   0,   5, 
    255, 255,   0,   1,   0,   0, 
    244,   2,   0,   0,  82,  68, 
     49,  49,  60,   0,   0,   0, 
     24,   0,   0,   0,  32,   0, 
      0,   0,  40,   0,   0,   0, 
     36,   0,   0,   0,  12,   0, 
      0,   0,   0,   0,   0,   0, 
    252,   0,   0,   0,   3,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      1,   0,   0,   0,   1,   0, 
      0,   0,   3,   1,   0,   0, 
      2,   0,   0,   0,   5,   0, 
      0,   0,   9,   0,   0,   0, 
    255, 255, 255, 255,   0,   0, 
      0,   0,   1,   0,   0,   0, 
     13,   0,   0,   0,  11,   1, 
      0,   0,   2,   0,   0,   0, 
      5,   0,   0,   0,   4,   0, 
      0,   0, 255, 255, 255, 255, 
      1,   0,   0,   0,   1,   0, 
      0,   0,  13,   0,   0,   0, 
     20,   1,   0,   0,   2,   0, 
      0,   0,   5,   0,   0,   0, 
      4,   0,   0,   0, 255, 255, 
    255, 255,   2,   0,   0,   0, 
      1,   0,   0,   0,  13,   0, 
      0,   0,  32,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   1,   0,   0,   0, 
      1,   0,   0,   0,  42,   1, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      1,   0,   0,   0,   1,   0, 
      0,   0,   1,   0,   0,   0, 
     70,  73,  76,  84,  69,  82, 
      0,  84,  69,  88,  84,  85, 
     82,  69,   0,  84, 101, 120, 
    116, 117, 114, 101,  49,   0, 
     84, 101, 120, 116, 117, 114, 
    101,  78, 111, 114, 109,   0, 
    116, 101, 120, 116, 117, 114, 
    105, 110, 103,   0,  67,  66, 
     95,  76, 105, 103, 104, 116, 
    115,   0,  32,   1,   0,   0, 
      2,   0,   0,   0, 100,   1, 
      0,   0,  16,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,  42,   1,   0,   0, 
      1,   0,   0,   0,  32,   2, 
      0,   0,   0,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0, 180,   1,   0,   0, 
      0,   0,   0,   0,   4,   0, 
      0,   0,   2,   0,   0,   0, 
    200,   1,   0,   0,   0,   0, 
      0,   0, 255, 255, 255, 255, 
      0,   0,   0,   0, 255, 255, 
    255, 255,   0,   0,   0,   0, 
    236,   1,   0,   0,   4,   0, 
      0,   0,  12,   0,   0,   0, 
      0,   0,   0,   0, 252,   1, 
      0,   0,   0,   0,   0,   0, 
    255, 255, 255, 255,   0,   0, 
      0,   0, 255, 255, 255, 255, 
      0,   0,   0,   0,  87, 104, 
    105,  99, 104,  84, 101, 120, 
    116, 117, 114, 101,   0, 102, 
    108, 111,  97, 116,   0, 171, 
      0,   0,   3,   0,   1,   0, 
      1,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0, 193,   1,   0,   0, 
    112,  97, 100, 100, 105, 110, 
    103,   0, 102, 108, 111,  97, 
    116,  51,   0, 171,   1,   0, 
      3,   0,   1,   0,   3,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
    244,   1,   0,   0,  72,   2, 
      0,   0,   0,   0,   0,   0, 
      0,   1,   0,   0,   2,   0, 
      0,   0, 208,   2,   0,   0, 
      0,   0,   0,   0, 255, 255, 
    255, 255,   0,   0,   0,   0, 
    255, 255, 255, 255,   0,   0, 
      0,   0, 108, 105, 115, 116, 
      0,  76, 105, 103, 104, 116, 
    115,   0,  80, 111, 115, 105, 
    116, 105, 111, 110,   0, 102, 
    108, 111,  97, 116,  52,   0, 
      1,   0,   3,   0,   1,   0, 
      4,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,  93,   2,   0,   0, 
     68, 105, 114, 101,  99, 116, 
    105, 111, 110,   0,  67, 111, 
    108, 111, 114,   0, 114,  97, 
    100, 105, 117, 115,   0, 171, 
     84,   2,   0,   0, 100,   2, 
      0,   0,   0,   0,   0,   0, 
    136,   2,   0,   0, 100,   2, 
      0,   0,  16,   0,   0,   0, 
    146,   2,   0,   0, 100,   2, 
      0,   0,  32,   0,   0,   0, 
    152,   2,   0,   0, 100,   2, 
      0,   0,  48,   0,   0,   0, 
      5,   0,   0,   0,   1,   0, 
     16,   0,   4,   0,   4,   0, 
    160,   2,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,  77,   2,   0,   0, 
     77, 105,  99, 114, 111, 115, 
    111, 102, 116,  32,  40,  82, 
     41,  32,  72,  76,  83,  76, 
     32,  83, 104,  97, 100, 101, 
    114,  32,  67, 111, 109, 112, 
    105, 108, 101, 114,  32,  54, 
     46,  51,  46,  57,  54,  48, 
     48,  46,  49,  54,  51,  56, 
     52,   0, 171, 171,  73,  83, 
     71,  78, 172,   1,   0,   0, 
     15,   0,   0,   0,   8,   0, 
      0,   0, 112,   1,   0,   0, 
      0,   0,   0,   0,   1,   0, 
      0,   0,   3,   0,   0,   0, 
      0,   0,   0,   0,  15,   0, 
      0,   0, 124,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      1,   0,   0,   0,   7,   3, 
      0,   0, 127,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      2,   0,   0,   0,   7,   7, 
      0,   0, 135,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      3,   0,   0,   0,   7,   7, 
      0,   0, 145,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      4,   0,   0,   0,   7,   7, 
      0,   0, 153,   1,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      5,   0,   0,   0,   7,   0, 
      0,   0, 163,   1,   0,   0, 
      1,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      6,   0,   0,   0,   3,   0, 
      0,   0, 163,   1,   0,   0, 
      2,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      6,   0,   0,   0,  12,   0, 
      0,   0, 163,   1,   0,   0, 
      3,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      7,   0,   0,   0,   3,   0, 
      0,   0, 163,   1,   0,   0, 
      4,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      7,   0,   0,   0,  12,   0, 
      0,   0, 163,   1,   0,   0, 
      5,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      8,   0,   0,   0,   3,   0, 
      0,   0, 163,   1,   0,   0, 
      6,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      8,   0,   0,   0,  12,   0, 
      0,   0, 163,   1,   0,   0, 
      7,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      9,   0,   0,   0,   3,   0, 
      0,   0, 163,   1,   0,   0, 
      8,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
      9,   0,   0,   0,  12,   0, 
      0,   0, 163,   1,   0,   0, 
      9,   0,   0,   0,   0,   0, 
      0,   0,   3,   0,   0,   0, 
     10,   0,   0,   0,   3,   0, 
      0,   0,  83,  86,  95,  80, 
     79,  83,  73,  84,  73,  79, 
     78,   0,  85,  86,   0,  78, 
     79,  82,  77,  65,  76,  83, 
      0,  80,  79,  83,  73,  84, 
     73,  79,  78,  87,   0,  84, 
     65,  78,  71,  69,  78,  84, 
      0,  66,  73,  84,  65,  78, 
     71,  69,  78,  84,   0,  84, 
     69,  88,  67,  79,  79,  82, 
     68,   0,  79,  83,  71,  78, 
     44,   0,   0,   0,   1,   0, 
      0,   0,   8,   0,   0,   0, 
     32,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      3,   0,   0,   0,   0,   0, 
      0,   0,  15,   0,   0,   0, 
     83,  86,  95,  84,  65,  82, 
     71,  69,  84,   0, 171, 171, 
     83,  72,  69,  88,  36,   9, 
      0,   0,  80,   0,   0,   0, 
     73,   2,   0,   0, 106,   8, 
      0,   1,  89,   0,   0,   4, 
     70, 142,  32,   0,   0,   0, 
      0,   0,   1,   0,   0,   0, 
     89,   0,   0,   4,  70, 142, 
     32,   0,   1,   0,   0,   0, 
     12,   0,   0,   0,  90,   0, 
      0,   3,   0,  96,  16,   0, 
      0,   0,   0,   0,  88,  48, 
      0,   4,   0, 112,  16,   0, 
      0,   0,   0,   0,  85,  85, 
      0,   0,  88,  24,   0,   4, 
      0, 112,  16,   0,   1,   0, 
      0,   0,  85,  85,   0,   0, 
     88,  24,   0,   4,   0, 112, 
     16,   0,   2,   0,   0,   0, 
     85,  85,   0,   0,  98,  16, 
      0,   3,  50,  16,  16,   0, 
      1,   0,   0,   0,  98,  16, 
      0,   3, 114,  16,  16,   0, 
      2,   0,   0,   0,  98,  16, 
      0,   3, 114,  16,  16,   0, 
      3,   0,   0,   0,  98,  16, 
      0,   3, 114,  16,  16,   0, 
      4,   0,   0,   0, 101,   0, 
      0,   3, 242,  32,  16,   0, 
      0,   0,   0,   0, 104,   0, 
      0,   2,   5,   0,   0,   0, 
     24,   0,   0,   8,  18,   0, 
     16,   0,   0,   0,   0,   0, 
     10, 128,  32,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      1,  64,   0,   0,   0,   0, 
      0,   0,  31,   0,   4,   3, 
     10,   0,  16,   0,   0,   0, 
      0,   0,  69,   0,   0, 139, 
    130,   1,   0, 128,  67,  85, 
     21,   0, 242,  32,  16,   0, 
      0,   0,   0,   0,  70,  18, 
     16,   0,   2,   0,   0,   0, 
     70, 126,  16,   0,   0,   0, 
      0,   0,   0,  96,  16,   0, 
      0,   0,   0,   0,  62,   0, 
      0,   1,  21,   0,   0,   1, 
     24,   0,   0,  11,  50,   0, 
     16,   0,   0,   0,   0,   0, 
      6, 128,  32,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      2,  64,   0,   0,   0,   0, 
    128,  63,   0,   0,   0,  64, 
      0,   0,   0,   0,   0,   0, 
      0,   0,  31,   0,   4,   3, 
     10,   0,  16,   0,   0,   0, 
      0,   0,  69,   0,   0, 139, 
    194,   0,   0, 128,  67,  85, 
     21,   0, 242,   0,  16,   0, 
      1,   0,   0,   0,  70,  16, 
     16,   0,   1,   0,   0,   0, 
     70, 126,  16,   0,   1,   0, 
      0,   0,   0,  96,  16,   0, 
      0,   0,   0,   0,  69,   0, 
      0, 139, 194,   0,   0, 128, 
     67,  85,  21,   0, 210,   0, 
     16,   0,   0,   0,   0,   0, 
     70,  16,  16,   0,   1,   0, 
      0,   0, 198, 121,  16,   0, 
      2,   0,   0,   0,   0,  96, 
     16,   0,   0,   0,   0,   0, 
     54,   0,   0,   5, 130,  32, 
     16,   0,   0,   0,   0,   0, 
     58,   0,  16,   0,   1,   0, 
      0,   0,  18,   0,   0,   1, 
     54,   0,   0,   8, 114,   0, 
     16,   0,   1,   0,   0,   0, 
      2,  64,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,  54,   0,   0,   8, 
    210,   0,  16,   0,   0,   0, 
      0,   0,   2,  64,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,  54,   0, 
      0,   5, 130,  32,  16,   0, 
      0,   0,   0,   0,   1,  64, 
      0,   0,   0,   0, 128,  63, 
     21,   0,   0,   1,  50,   0, 
      0,  15, 210,   0,  16,   0, 
      0,   0,   0,   0,   6,  14, 
     16,   0,   0,   0,   0,   0, 
      2,  64,   0,   0,   0,   0, 
      0,  64,   0,   0,   0,   0, 
      0,   0,   0,  64,   0,   0, 
      0,  64,   2,  64,   0,   0, 
      0,   0, 128, 191,   0,   0, 
      0,   0,   0,   0, 128, 191, 
      0,   0, 128, 191,  16,   0, 
      0,   7,  18,   0,  16,   0, 
      2,   0,   0,   0,  70,  18, 
     16,   0,   2,   0,   0,   0, 
     70,  18,  16,   0,   2,   0, 
      0,   0,  68,   0,   0,   5, 
     18,   0,  16,   0,   2,   0, 
      0,   0,  10,   0,  16,   0, 
      2,   0,   0,   0,  56,   0, 
      0,   7, 114,   0,  16,   0, 
      2,   0,   0,   0,   6,   0, 
     16,   0,   2,   0,   0,   0, 
     70,  18,  16,   0,   2,   0, 
      0,   0,  16,   0,   0,   7, 
    130,   0,  16,   0,   2,   0, 
      0,   0,  70,  18,  16,   0, 
      4,   0,   0,   0,  70,  18, 
     16,   0,   4,   0,   0,   0, 
     68,   0,   0,   5, 130,   0, 
     16,   0,   2,   0,   0,   0, 
     58,   0,  16,   0,   2,   0, 
      0,   0,  56,   0,   0,   7, 
    114,   0,  16,   0,   3,   0, 
      0,   0, 246,  15,  16,   0, 
      2,   0,   0,   0,  70,  18, 
     16,   0,   4,   0,   0,   0, 
     56,   0,   0,   7, 114,   0, 
     16,   0,   4,   0,   0,   0, 
     38,   9,  16,   0,   2,   0, 
      0,   0, 150,   4,  16,   0, 
      3,   0,   0,   0,  50,   0, 
      0,  10, 114,   0,  16,   0, 
      4,   0,   0,   0, 150,   4, 
     16,   0,   2,   0,   0,   0, 
     38,   9,  16,   0,   3,   0, 
      0,   0,  70,   2,  16, 128, 
     65,   0,   0,   0,   4,   0, 
      0,   0,  16,   0,   0,   7, 
    130,   0,  16,   0,   2,   0, 
      0,   0,  70,   2,  16,   0, 
      4,   0,   0,   0,  70,   2, 
     16,   0,   4,   0,   0,   0, 
     68,   0,   0,   5, 130,   0, 
     16,   0,   2,   0,   0,   0, 
     58,   0,  16,   0,   2,   0, 
      0,   0,  56,   0,   0,   7, 
    114,   0,  16,   0,   4,   0, 
      0,   0, 246,  15,  16,   0, 
      2,   0,   0,   0,  70,   2, 
     16,   0,   4,   0,   0,   0, 
     56,   0,   0,   7, 114,   0, 
     16,   0,   4,   0,   0,   0, 
    166,  10,  16,   0,   0,   0, 
      0,   0,  70,   2,  16,   0, 
      4,   0,   0,   0,  50,   0, 
      0,   9, 114,   0,  16,   0, 
      3,   0,   0,   0,   6,   0, 
     16,   0,   0,   0,   0,   0, 
     70,   2,  16,   0,   3,   0, 
      0,   0,  70,   2,  16,   0, 
      4,   0,   0,   0,  50,   0, 
      0,   9, 210,   0,  16,   0, 
      0,   0,   0,   0, 246,  15, 
     16,   0,   0,   0,   0,   0, 
      6,   9,  16,   0,   2,   0, 
      0,   0,   6,   9,  16,   0, 
      3,   0,   0,   0,  31,   0, 
      4,   3,  26,   0,  16,   0, 
      0,   0,   0,   0,  69,   0, 
      0, 139, 194,   0,   0, 128, 
     67,  85,  21,   0, 242,   0, 
     16,   0,   1,   0,   0,   0, 
     70,  16,  16,   0,   1,   0, 
      0,   0,  70, 126,  16,   0, 
      1,   0,   0,   0,   0,  96, 
     16,   0,   0,   0,   0,   0, 
     54,   0,   0,   5, 130,  32, 
     16,   0,   0,   0,   0,   0, 
     58,   0,  16,   0,   1,   0, 
      0,   0,  21,   0,   0,   1, 
     55,   0,   0,   9, 114,   0, 
     16,   0,   0,   0,   0,   0, 
     86,   5,  16,   0,   0,   0, 
      0,   0,  70,  18,  16,   0, 
      2,   0,   0,   0, 134,   3, 
     16,   0,   0,   0,   0,   0, 
     24,   0,   0,   8, 130,   0, 
     16,   0,   0,   0,   0,   0, 
     10, 128,  32,   0,   1,   0, 
      0,   0,   3,   0,   0,   0, 
      1,  64,   0,   0,   0,   0, 
    128,  63,  17,   0,   0,   9, 
    130,   0,  16,   0,   1,   0, 
      0,   0,  70, 142,  32,   0, 
      1,   0,   0,   0,   1,   0, 
      0,   0,  70, 142,  32,   0, 
      1,   0,   0,   0,   1,   0, 
      0,   0,  68,   0,   0,   5, 
    130,   0,  16,   0,   1,   0, 
      0,   0,  58,   0,  16,   0, 
      1,   0,   0,   0,  56,   0, 
      0,   8, 114,   0,  16,   0, 
      2,   0,   0,   0, 246,  15, 
     16,   0,   1,   0,   0,   0, 
     70, 130,  32,   0,   1,   0, 
      0,   0,   1,   0,   0,   0, 
     16,   0,   0,   7, 130,   0, 
     16,   0,   1,   0,   0,   0, 
     70,   2,  16,   0,   0,   0, 
      0,   0,  70,   2,  16,   0, 
      0,   0,   0,   0,  68,   0, 
      0,   5, 130,   0,  16,   0, 
      1,   0,   0,   0,  58,   0, 
     16,   0,   1,   0,   0,   0, 
     56,   0,   0,   7, 114,   0, 
     16,   0,   0,   0,   0,   0, 
     70,   2,  16,   0,   0,   0, 
      0,   0, 246,  15,  16,   0, 
      1,   0,   0,   0,  16,  32, 
      0,   8, 130,   0,  16,   0, 
      1,   0,   0,   0,  70,   2, 
     16, 128,  65,   0,   0,   0, 
      2,   0,   0,   0,  70,   2, 
     16,   0,   0,   0,   0,   0, 
     56,   0,   0,   8, 114,   0, 
     16,   0,   2,   0,   0,   0, 
    246,  15,  16,   0,   1,   0, 
      0,   0,  70, 130,  32,   0, 
      1,   0,   0,   0,   2,   0, 
      0,   0,   1,   0,   0,   7, 
    114,   0,  16,   0,   2,   0, 
      0,   0, 246,  15,  16,   0, 
      0,   0,   0,   0,  70,   2, 
     16,   0,   2,   0,   0,   0, 
     24,   0,   0,   8, 130,   0, 
     16,   0,   0,   0,   0,   0, 
     10, 128,  32,   0,   1,   0, 
      0,   0,   7,   0,   0,   0, 
      1,  64,   0,   0,   0,   0, 
    128,  63,   0,   0,   0,   9, 
    114,   0,  16,   0,   3,   0, 
      0,   0,  70,  18,  16, 128, 
     65,   0,   0,   0,   3,   0, 
      0,   0,  70, 130,  32,   0, 
      1,   0,   0,   0,   4,   0, 
      0,   0,  16,   0,   0,   7, 
    130,   0,  16,   0,   1,   0, 
      0,   0,  70,   2,  16,   0, 
      3,   0,   0,   0,  70,   2, 
     16,   0,   3,   0,   0,   0, 
     68,   0,   0,   5, 130,   0, 
     16,   0,   2,   0,   0,   0, 
     58,   0,  16,   0,   1,   0, 
      0,   0,  56,   0,   0,   7, 
    114,   0,  16,   0,   3,   0, 
      0,   0, 246,  15,  16,   0, 
      2,   0,   0,   0,  70,   2, 
     16,   0,   3,   0,   0,   0, 
     16,  32,   0,   7, 130,   0, 
     16,   0,   2,   0,   0,   0, 
     70,   2,  16,   0,   3,   0, 
      0,   0,  70,   2,  16,   0, 
      0,   0,   0,   0,  75,   0, 
      0,   5, 130,   0,  16,   0, 
      1,   0,   0,   0,  58,   0, 
     16,   0,   1,   0,   0,   0, 
     14,  32,   0,   8, 130,   0, 
     16,   0,   1,   0,   0,   0, 
     58,   0,  16,   0,   1,   0, 
      0,   0,  58, 128,  32,   0, 
      1,   0,   0,   0,   7,   0, 
      0,   0,   0,   0,   0,   8, 
    130,   0,  16,   0,   1,   0, 
      0,   0,  58,   0,  16, 128, 
     65,   0,   0,   0,   1,   0, 
      0,   0,   1,  64,   0,   0, 
      0,   0, 128,  63,  56,   0, 
      0,   8, 114,   0,  16,   0, 
      3,   0,   0,   0, 246,  15, 
     16,   0,   2,   0,   0,   0, 
     70, 130,  32,   0,   1,   0, 
      0,   0,   6,   0,   0,   0, 
     50,   0,   0,   9, 114,   0, 
     16,   0,   3,   0,   0,   0, 
     70,   2,  16,   0,   3,   0, 
      0,   0, 246,  15,  16,   0, 
      1,   0,   0,   0,  70,   2, 
     16,   0,   2,   0,   0,   0, 
     55,   0,   0,   9, 114,   0, 
     16,   0,   2,   0,   0,   0, 
    246,  15,  16,   0,   0,   0, 
      0,   0,  70,   2,  16,   0, 
      3,   0,   0,   0,  70,   2, 
     16,   0,   2,   0,   0,   0, 
     24,   0,   0,   8, 130,   0, 
     16,   0,   0,   0,   0,   0, 
     10, 128,  32,   0,   1,   0, 
      0,   0,  11,   0,   0,   0, 
      1,  64,   0,   0,   0,   0, 
    128,  63,   0,   0,   0,   9, 
    114,   0,  16,   0,   3,   0, 
      0,   0,  70,  18,  16, 128, 
     65,   0,   0,   0,   3,   0, 
      0,   0,  70, 130,  32,   0, 
      1,   0,   0,   0,   8,   0, 
      0,   0,  16,   0,   0,   7, 
    130,   0,  16,   0,   1,   0, 
      0,   0,  70,   2,  16,   0, 
      3,   0,   0,   0,  70,   2, 
     16,   0,   3,   0,   0,   0, 
     68,   0,   0,   5, 130,   0, 
     16,   0,   1,   0,   0,   0, 
     58,   0,  16,   0,   1,   0, 
      0,   0,  56,   0,   0,   7, 
    114,   0,  16,   0,   3,   0, 
      0,   0, 246,  15,  16,   0, 
      1,   0,   0,   0,  70,   2, 
     16,   0,   3,   0,   0,   0, 
     16,  32,   0,   9, 130,   0, 
     16,   0,   1,   0,   0,   0, 
     70,   2,  16, 128,  65,   0, 
      0,   0,   3,   0,   0,   0, 
     70, 130,  32,   0,   1,   0, 
      0,   0,   9,   0,   0,   0, 
     49,   0,   0,   8, 130,   0, 
     16,   0,   2,   0,   0,   0, 
     58, 128,  32,   0,   1,   0, 
      0,   0,  11,   0,   0,   0, 
     58,   0,  16,   0,   1,   0, 
      0,   0,   1,   0,   0,   7, 
    130,   0,  16,   0,   2,   0, 
      0,   0,  58,   0,  16,   0, 
      2,   0,   0,   0,   1,  64, 
      0,   0,   0,   0, 128,  63, 
     16,  32,   0,   7,  18,   0, 
     16,   0,   0,   0,   0,   0, 
     70,   2,  16,   0,   3,   0, 
      0,   0,  70,   2,  16,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   9,  34,   0,  16,   0, 
      0,   0,   0,   0,  58,   0, 
     16, 128,  65,   0,   0,   0, 
      1,   0,   0,   0,  26, 128, 
     32,   0,   1,   0,   0,   0, 
     11,   0,   0,   0,   0,   0, 
      0,  10,  66,   0,  16,   0, 
      0,   0,   0,   0,  42, 128, 
     32, 128,  65,   0,   0,   0, 
      1,   0,   0,   0,  11,   0, 
      0,   0,  26, 128,  32,   0, 
      1,   0,   0,   0,  11,   0, 
      0,   0,  14,  32,   0,   7, 
     34,   0,  16,   0,   0,   0, 
      0,   0,  26,   0,  16,   0, 
      0,   0,   0,   0,  42,   0, 
     16,   0,   0,   0,   0,   0, 
      0,   0,   0,   8,  34,   0, 
     16,   0,   0,   0,   0,   0, 
     26,   0,  16, 128,  65,   0, 
      0,   0,   0,   0,   0,   0, 
      1,  64,   0,   0,   0,   0, 
    128,  63,  56,   0,   0,   7, 
     18,   0,  16,   0,   0,   0, 
      0,   0,  10,   0,  16,   0, 
      0,   0,   0,   0,  58,   0, 
     16,   0,   2,   0,   0,   0, 
     56,   0,   0,   8, 114,   0, 
     16,   0,   3,   0,   0,   0, 
      6,   0,  16,   0,   0,   0, 
      0,   0,  70, 130,  32,   0, 
      1,   0,   0,   0,  10,   0, 
      0,   0,  56,   0,   0,   7, 
     18,   0,  16,   0,   0,   0, 
      0,   0,  26,   0,  16,   0, 
      0,   0,   0,   0,  26,   0, 
     16,   0,   0,   0,   0,   0, 
     50,   0,   0,   9, 114,   0, 
     16,   0,   0,   0,   0,   0, 
      6,   0,  16,   0,   0,   0, 
      0,   0,  70,   2,  16,   0, 
      3,   0,   0,   0,  70,   2, 
     16,   0,   2,   0,   0,   0, 
     55,   0,   0,   9, 114,   0, 
     16,   0,   0,   0,   0,   0, 
    246,  15,  16,   0,   0,   0, 
      0,   0,  70,   2,  16,   0, 
      0,   0,   0,   0,  70,   2, 
     16,   0,   2,   0,   0,   0, 
     56,   0,   0,   7, 114,  32, 
     16,   0,   0,   0,   0,   0, 
     70,   2,  16,   0,   1,   0, 
      0,   0,  70,   2,  16,   0, 
      0,   0,   0,   0,  62,   0, 
      0,   1,  83,  84,  65,  84, 
    148,   0,   0,   0,  77,   0, 
      0,   0,   5,   0,   0,   0, 
      0,   0,   0,   0,   5,   0, 
      0,   0,  54,   0,   0,   0, 
      0,   0,   0,   0,   2,   0, 
      0,   0,   3,   0,   0,   0, 
      3,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      4,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   5,   0,   0,   0, 
      3,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0,   0,   0,   0,   0, 
      0,   0
};
