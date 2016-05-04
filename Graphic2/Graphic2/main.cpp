
//************************************************************
//************ INCLUDES & DEFINES ****************************
//************************************************************


#include "XTime.h"
#include "Defines.h"

#include <d3d11.h>
#pragma comment (lib, "d3d11.lib")


#include "Trivial_VS.csh"
#include "Trivial_PS.csh"
#include "PixelShader.csh"
#include "VertexShader.csh"



#define BACKBUFFER_WIDTH	500
#define BACKBUFFER_HEIGHT	500

ID3D11DeviceContext*	g_pd3dDeviceContext;
IDXGISwapChain*			g_pSwapChain;
ID3D11RenderTargetView* g_pRenderTargetView;
ID3D11Device*			g_pd3dDevice;
ID3D11DepthStencilView* g_StencilView;
ID3D11Texture2D*		g_TexBuffer;
D3D11_VIEWPORT			g_DirectView;
bool g_ScreenChanged;
XMMATRIX g_newProjection;


//************************************************************
//************ SIMPLE WINDOWS APP CLASS **********************
//************************************************************

class DEMO_APP
{	
	HINSTANCE						application;
	WNDPROC							appWndProc;
	HWND							window;
	XTime							TimeWizard;
	ID3D11Buffer*					VertexBufferStar;
	ID3D11Buffer*					IndexBufferStar;
	ID3D11VertexShader*				DirectVertShader[2];
	ID3D11PixelShader*				DirectPixShader[2];
	ID3D11InputLayout*				DirectInputLay[2];
	ID3D11Buffer*					CostantBuffer[2];
	ID3D11Buffer*					CostantPixelBuffer;


	void init3D(HWND hWnd);
	void Clean3d();
	SEND_TO_VRAM_WORLD WorldShader;
	SEND_TO_VRAM_PIXEL VRAMPixelShader;
	TRANSLATOR translating;
	XMMATRIX m_viewMatrix;
	POINT prevPoint;
	POINT newPoint;
	bool Checked;
public:
	

	DEMO_APP(HINSTANCE hinst, WNDPROC proc);
	bool Run();
	bool ShutDown();
};

//************************************************************
//************ CREATION OF OBJECTS & RESOURCES ***************
//************************************************************

DEMO_APP::DEMO_APP(HINSTANCE hinst, WNDPROC proc)
{

	
	application = hinst; 
	appWndProc = proc; 

	WNDCLASSEX  wndClass;
    ZeroMemory( &wndClass, sizeof( wndClass ) );
    wndClass.cbSize         = sizeof( WNDCLASSEX );             
    wndClass.lpfnWndProc    = appWndProc;						
    wndClass.lpszClassName  = L"DirectXApplication";            
	wndClass.hInstance      = application;		               
    wndClass.hCursor        = LoadCursor( NULL, IDC_ARROW );    
    wndClass.hbrBackground  = ( HBRUSH )( COLOR_WINDOWFRAME ); 
	//wndClass.hIcon			= LoadIcon(GetModuleHandle(NULL), MAKEINTRESOURCE(IDI_FSICON));
    RegisterClassEx( &wndClass );

	RECT window_size = { 0, 0, BACKBUFFER_WIDTH, BACKBUFFER_HEIGHT };
	AdjustWindowRect(&window_size, WS_OVERLAPPEDWINDOW, false);

	window = CreateWindow(	L"DirectXApplication", L"GRAPHIC 2 PROJECT",	WS_OVERLAPPEDWINDOW , 
							CW_USEDEFAULT, CW_USEDEFAULT, window_size.right-window_size.left, window_size.bottom-window_size.top,					
							NULL, NULL,	application, this );												

    ShowWindow( window, SW_SHOW );
	
#pragma region Initialization
	//Initalizing ID3D11Device & IDXGISwapChain & ViewPorts objects
	init3D(window);
	WorldShader.worldMatrix = XMMatrixIdentity();
	WorldShader.viewMatrix = XMMatrixIdentity();
	WorldShader.projectView = XMMatrixIdentity();
	g_newProjection = XMMatrixIdentity();
	m_viewMatrix = XMMatrixIdentity();
	m_viewMatrix = XMMatrixTranslation(0.0f, 1.0f, -3.0f);
	WorldShader.projectView = XMMatrixPerspectiveFovLH(XMConvertToRadians(FIELDOFVIEW), ASPECTRATIO, ZNEAR, ZFAR);

	translating.Translate = XMMatrixIdentity();
	translating.Rotation = XMMatrixIdentity();
	translating.Scale = 1;
	g_ScreenChanged = false;
#pragma endregion

#pragma region Creating Star Shape

	bool toggle = true;
	SIMPLE_VERTEX Star[12];

	Star[10].XYZW = XMFLOAT4(0, 2, -0.25f, 1);
	Star[10].RGBA = XMFLOAT4(1, 0, 1, 1);

	Star[11].XYZW = XMFLOAT4(0, 2, 0.25f, 1);
	Star[11].RGBA = XMFLOAT4(0, 0, 1, 1);

	for (unsigned int i = 0; i < 10; i++)
	{
		if (toggle)
		{
			Star[i].XYZW = XMFLOAT4(sin(((i * 36) * 3.14159f) / 180), 
				cos(((i * 36) * 3.14159f) / 180) + 2, 0.0f , 1);
			Star[i].RGBA = XMFLOAT4(1, 0, 0, 1);
		}
		else
		{
			Star[i].XYZW = XMFLOAT4(sin(((i * 36) * 3.14159f) / 180) * .50f,
				cos(((i * 36) * 3.14159f) / 180) * .50f + 2, 0.0f, 1);
			Star[i].RGBA = XMFLOAT4(1, 0, 0, 1);
		}

		toggle = !toggle;
	}

	unsigned int indice[60] =
	{
		0, 1, 10, 1, 2, 10, 2, 3, 10, 3, 4, 10, 4, 5, 10, 5, 6, 10, 6, 7, 10, 7, 8, 10, 8, 9, 10, 9, 0, 10,
		0, 9, 11, 9, 8, 11, 8, 7, 11, 7, 6, 11, 6, 5, 11, 5, 4, 11, 4, 3, 11, 3, 2, 11, 2, 1, 11, 1, 0, 11
	};

#pragma endregion

#pragma region Creating Plane

	
	

#pragma endregion


//Creating Buffers
#pragma region VertexBuffer for Star
	D3D11_BUFFER_DESC StarbufferDesc;
	ZeroMemory(&StarbufferDesc, sizeof(StarbufferDesc));
	StarbufferDesc.Usage = D3D11_USAGE_IMMUTABLE;
	StarbufferDesc.BindFlags = D3D11_BIND_VERTEX_BUFFER;
	StarbufferDesc.ByteWidth = sizeof(SIMPLE_VERTEX) * 12;

	D3D11_SUBRESOURCE_DATA sub_data;
	ZeroMemory(&sub_data, sizeof(sub_data));
	sub_data.pSysMem = Star;
	g_pd3dDevice->CreateBuffer(&StarbufferDesc, &sub_data, &VertexBufferStar);
#pragma endregion

#pragma region IndexBuffer for Star
	D3D11_BUFFER_DESC indexBuffDesc;
	ZeroMemory(&indexBuffDesc, sizeof(indexBuffDesc));
	indexBuffDesc.Usage = D3D11_USAGE_IMMUTABLE;
	indexBuffDesc.BindFlags = D3D11_BIND_INDEX_BUFFER;
	indexBuffDesc.ByteWidth = sizeof(indice);

	D3D11_SUBRESOURCE_DATA indexData;
	ZeroMemory(&indexData, sizeof(indexData));
	indexData.pSysMem = &indice;
	g_pd3dDevice->CreateBuffer(&indexBuffDesc, &indexData, &IndexBufferStar);
#pragma endregion

#pragma region ShaderData
	g_pd3dDevice->CreateVertexShader(Trivial_VS, sizeof(Trivial_VS), NULL, &DirectVertShader[0]);
	g_pd3dDevice->CreatePixelShader(Trivial_PS, sizeof(Trivial_PS), NULL, &DirectPixShader[0]);
	g_pd3dDevice->CreateVertexShader(VertexShader, sizeof(VertexShader), NULL, &DirectVertShader[1]);
	g_pd3dDevice->CreatePixelShader(PixelShader, sizeof(PixelShader), NULL, &DirectPixShader[1]);

	D3D11_INPUT_ELEMENT_DESC LayoutComplex[] =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, D3D11_INPUT_PER_VERTEX_DATA },
		{ "UV", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, D3D11_INPUT_PER_VERTEX_DATA, 0 },
		{ "NORMALS", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, D3D11_INPUT_PER_VERTEX_DATA, 0 },
	};

	D3D11_INPUT_ELEMENT_DESC LayoutSimple[] =
	{
		{ "POSITION", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, D3D11_INPUT_PER_VERTEX_DATA },
		{ "COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, D3D11_APPEND_ALIGNED_ELEMENT, D3D11_INPUT_PER_VERTEX_DATA, 0 },
	};

	g_pd3dDevice->CreateInputLayout(LayoutComplex, 3, Trivial_VS, sizeof(Trivial_VS), &DirectInputLay[0]);
	g_pd3dDevice->CreateInputLayout(LayoutSimple, 2, VertexShader, sizeof(VertexShader), &DirectInputLay[1]);

#pragma endregion

#pragma region Costant Buffers

	D3D11_BUFFER_DESC BufferDesc2;
	ZeroMemory(&BufferDesc2, sizeof(BufferDesc2));
	BufferDesc2.Usage = D3D11_USAGE_DYNAMIC;
	BufferDesc2.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	BufferDesc2.ByteWidth = sizeof(SEND_TO_VRAM_WORLD);
	BufferDesc2.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	g_pd3dDevice->CreateBuffer(&BufferDesc2, NULL, &CostantBuffer[0]);

	D3D11_BUFFER_DESC BufferDesc5;
	ZeroMemory(&BufferDesc5, sizeof(BufferDesc5));
	BufferDesc5.Usage = D3D11_USAGE_DYNAMIC;
	BufferDesc5.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	BufferDesc5.ByteWidth = sizeof(TRANSLATOR);
	BufferDesc5.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	g_pd3dDevice->CreateBuffer(&BufferDesc5, NULL, &CostantBuffer[1]);

	D3D11_BUFFER_DESC BufferDesc3;
	ZeroMemory(&BufferDesc3, sizeof(BufferDesc3));
	BufferDesc3.Usage = D3D11_USAGE_DYNAMIC;
	BufferDesc3.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
	BufferDesc3.ByteWidth = sizeof(SEND_TO_VRAM_PIXEL);
	BufferDesc3.CPUAccessFlags = D3D11_CPU_ACCESS_WRITE;
	g_pd3dDevice->CreateBuffer(&BufferDesc3, NULL, &CostantPixelBuffer);
#pragma endregion

#pragma region Depth Buffer
	//Creating DepthStencil initlization
	//DXGI_FORMAT_R32G32B32A32_FLOAT
	//DXGI_FORMAT_D32_FLOAT
	D3D11_TEXTURE2D_DESC texture2D;
	ZeroMemory(&texture2D, sizeof(texture2D));
	texture2D.Width = BACKBUFFER_WIDTH;
	texture2D.Height = BACKBUFFER_HEIGHT;
	texture2D.Usage = D3D11_USAGE_DEFAULT;
	texture2D.BindFlags = D3D11_BIND_DEPTH_STENCIL;
	texture2D.Format = DXGI_FORMAT_D32_FLOAT;
	texture2D.MipLevels = 1;
	texture2D.ArraySize = 1;
	texture2D.SampleDesc.Count = 1;
	g_pd3dDevice->CreateTexture2D(&texture2D, NULL, &g_TexBuffer);

	D3D11_DEPTH_STENCIL_VIEW_DESC stencil;
	ZeroMemory(&stencil, sizeof(stencil));
	stencil.Format = DXGI_FORMAT_D32_FLOAT;
	stencil.ViewDimension = D3D11_DSV_DIMENSION_TEXTURE2DMS;		//use this enum to incorporate sampleDecs.count/.Quality values otherwise use D3D11_DSV_DIMENSION_TEXTURE2D
	stencil.Texture2D.MipSlice = 0;
	g_pd3dDevice->CreateDepthStencilView(g_TexBuffer, &stencil, &g_StencilView);
#pragma endregion

	TimeWizard.Restart();
}

void DEMO_APP::init3D(HWND hWnd)
{

#pragma region Initail stuff
	// create a struct to hold information about the swap chain
	DXGI_SWAP_CHAIN_DESC scd;

	// clear out the struct for use
	ZeroMemory(&scd, sizeof(DXGI_SWAP_CHAIN_DESC));

	// fill the swap chain description struct
	scd.BufferCount = 1;                                    // one back buffer
	scd.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;     // use 32-bit color
	scd.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;      // how swap chain is to be used
	scd.BufferDesc.Width = BACKBUFFER_WIDTH;
	scd.BufferDesc.Height = BACKBUFFER_HEIGHT;
	scd.OutputWindow = hWnd;                                // the window to be used
	scd.SampleDesc.Count = 1;                               // how many multisamples
															//scd.SampleDesc.Quality = 1;								
	scd.Windowed = TRUE;                                    // windowed/full-screen mode
	scd.Flags = DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH;		// Special Flags
	scd.BufferDesc.Scaling = DXGI_MODE_SCALING_CENTERED;
	scd.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;

	unsigned int flags = 0;
#ifdef _DEBUG
	flags = D3D11_CREATE_DEVICE_DEBUG;
#endif

	// create a device, device context and swap chain using the information in the scd struct
	D3D11CreateDeviceAndSwapChain(NULL,
		D3D_DRIVER_TYPE_HARDWARE,
		NULL,
		flags,
		NULL,
		NULL,
		D3D11_SDK_VERSION,
		&scd,
		&g_pSwapChain,
		&g_pd3dDevice,
		NULL,
		&g_pd3dDeviceContext);
#pragma endregion

#pragma region BackBuffer Stuff
	//Getting Temp BackBuffer to reference
	ID3D11Texture2D* tempBuffer;
	g_pSwapChain->GetBuffer(0, __uuidof(ID3D11Texture2D), (LPVOID*)&tempBuffer);

	//using the tempbuffer address to created ID3D11RenderTargetView object
	g_pd3dDevice->CreateRenderTargetView(tempBuffer, NULL, &g_pRenderTargetView);
	//I don't need this anymore so I release it to the wild
	tempBuffer->Release();

	//Setting Rendertarget as back buffer
	g_pd3dDeviceContext->OMSetRenderTargets(1, &g_pRenderTargetView, NULL);
#pragma endregion

#pragma region Viewport
	//Setting VeiwPort
	ZeroMemory(&g_DirectView, sizeof(D3D11_VIEWPORT));

	g_DirectView.TopLeftX = 0;
	g_DirectView.TopLeftY = 0;
	g_DirectView.Width = BACKBUFFER_WIDTH;
	g_DirectView.Height = BACKBUFFER_HEIGHT;
	g_DirectView.MinDepth = 0;
	g_DirectView.MaxDepth = 1.0f;

#pragma endregion

}

//************************************************************
//************ EXECUTION *************************************
//************************************************************

bool DEMO_APP::Run()
{
	TimeWizard.Signal();

	float timer = (float)TimeWizard.Delta();
	WorldShader.worldMatrix = XMMatrixMultiply(XMMatrixRotationY(timer), WorldShader.worldMatrix);

	if (g_ScreenChanged)
	{
		WorldShader.projectView = g_newProjection;
		g_ScreenChanged = false;
	}

	g_pd3dDeviceContext->OMSetRenderTargets(1, &g_pRenderTargetView, g_StencilView);
	g_pd3dDeviceContext->RSSetViewports(1, &g_DirectView);

	float temp[4] = { 0.0f, 0.1f, 0.3f, 1.0f };
	g_pd3dDeviceContext->ClearRenderTargetView(g_pRenderTargetView, temp);
	g_pd3dDeviceContext->ClearDepthStencilView(g_StencilView, D3D11_CLEAR_DEPTH, 1.0f, 0);
	
#pragma region ControlCamera

	XMMATRIX T;

	if (GetAsyncKeyState('W'))
	{
		
		T = XMMatrixTranslation(0, 0, TimeWizard.Delta());
		m_viewMatrix = XMMatrixMultiply(T, m_viewMatrix);
	}
	if (GetAsyncKeyState('S'))
	{
		T = XMMatrixTranslation(0, 0, -TimeWizard.Delta());
		m_viewMatrix = XMMatrixMultiply(T, m_viewMatrix);
	}

	XMMATRIX L;
	if (GetAsyncKeyState('D'))
	{
		
		L = XMMatrixTranslation(TimeWizard.Delta(), 0, 0);
		m_viewMatrix = XMMatrixMultiply(L, m_viewMatrix);
	}
	if (GetAsyncKeyState('A'))
	{
		
		L = XMMatrixTranslation(-TimeWizard.Delta(), 0, 0);
		m_viewMatrix = XMMatrixMultiply(L, m_viewMatrix);
	}

	XMMATRIX C;
	if (GetAsyncKeyState(VK_UP))
	{
		
		C = XMMatrixTranslation(0, TimeWizard.Delta(), 0);
		m_viewMatrix = XMMatrixMultiply(m_viewMatrix, C);
	}
	if (GetAsyncKeyState(VK_DOWN))
	{
		C = XMMatrixTranslation(0, -TimeWizard.Delta(), 0);
		m_viewMatrix = XMMatrixMultiply(m_viewMatrix, C);
	}


	XMVECTOR TempXYZW = m_viewMatrix.r[3];


	if (GetAsyncKeyState(VK_LBUTTON))
	{
		m_viewMatrix.r[3].m128_f32[0] = 0.0f;
		m_viewMatrix.r[3].m128_f32[1] = 0.0f;
		m_viewMatrix.r[3].m128_f32[2] = 0.0f;
		m_viewMatrix.r[3].m128_f32[3] = 1.0f;

		GetCursorPos(&newPoint);

		if (!Checked)
		{
			prevPoint = newPoint;
		}

		if (prevPoint.x != newPoint.x)
		{
			m_viewMatrix = XMMatrixMultiply(m_viewMatrix, XMMatrixRotationY((prevPoint.x - newPoint.x) * .1f)); //Global
		}
		if (prevPoint.y != newPoint.y)
		{
			m_viewMatrix = XMMatrixMultiply(XMMatrixRotationY((prevPoint.y - newPoint.y) * .1f), m_viewMatrix); //LOCAL
		}

		prevPoint = newPoint;
		Checked = true;
	}
	else
	{
		Checked = false;
	}
	m_viewMatrix.r[3] = TempXYZW;


	WorldShader.viewMatrix = XMMatrixInverse(nullptr,m_viewMatrix);
#pragma endregion

#pragma region Updating Video Buffers
	//Sending NEW worldMARIX, viewMatrix, projectionMATRIX to videocard
	D3D11_MAPPED_SUBRESOURCE m_mapSource;
	g_pd3dDeviceContext->Map(CostantBuffer[0], 0, D3D11_MAP_WRITE_DISCARD, 0, &m_mapSource);
	memcpy_s(m_mapSource.pData, sizeof(SEND_TO_VRAM_WORLD), &WorldShader, sizeof(SEND_TO_VRAM_WORLD));
	g_pd3dDeviceContext->Unmap(CostantBuffer[0], 0);

	//Sending NEW rotation, scale, translation to videocard
	D3D11_MAPPED_SUBRESOURCE m_mapSource2;
	g_pd3dDeviceContext->Map(CostantBuffer[1], 0, D3D11_MAP_WRITE_DISCARD, 0, &m_mapSource2);
	memcpy_s(m_mapSource2.pData, sizeof(TRANSLATOR), &translating, sizeof(TRANSLATOR));
	g_pd3dDeviceContext->Unmap(CostantBuffer[1], 0);

	//Sending NEW UVs to videocard
	D3D11_MAPPED_SUBRESOURCE m_mapSource1;
	g_pd3dDeviceContext->Map(CostantPixelBuffer, 0, D3D11_MAP_WRITE_DISCARD, 0, &m_mapSource1);
	memcpy_s(m_mapSource1.pData, sizeof(SEND_TO_VRAM_PIXEL), &VRAMPixelShader, sizeof(SEND_TO_VRAM_PIXEL));
	g_pd3dDeviceContext->Unmap(CostantPixelBuffer, 0);

	g_pd3dDeviceContext->VSSetConstantBuffers(0, 1, &CostantBuffer[0]);
	g_pd3dDeviceContext->VSSetConstantBuffers(1, 1, &CostantBuffer[1]);
	g_pd3dDeviceContext->PSSetConstantBuffers(0, 1, &CostantPixelBuffer);
#pragma endregion

#pragma region Drawing Star
	unsigned int stride = sizeof(SIMPLE_VERTEX);	
	unsigned int offsets = 0;
	g_pd3dDeviceContext->IASetVertexBuffers(0, 1, &VertexBufferStar, &stride, &offsets);

	g_pd3dDeviceContext->IASetInputLayout(DirectInputLay[1]);
	g_pd3dDeviceContext->VSSetShader(DirectVertShader[1], NULL, NULL);
	g_pd3dDeviceContext->PSSetShader(DirectPixShader[1], NULL, NULL);



	g_pd3dDeviceContext->IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
	g_pd3dDeviceContext->IASetIndexBuffer(IndexBufferStar, DXGI_FORMAT_R32_UINT, 0);

	g_pd3dDeviceContext->DrawIndexed(60, 0, 0);
#pragma endregion

	g_pSwapChain->Present(0, 0);

	return true; 
}

//************************************************************
//************ DESTRUCTION ***********************************
//************************************************************

bool DEMO_APP::ShutDown()
{
	Clean3d();
	
	UnregisterClass( L"DirectXApplication", application ); 
	return true;
}

void DEMO_APP::Clean3d()
{
	g_pd3dDeviceContext->Release();
	g_pSwapChain->Release();
	g_pRenderTargetView->Release();
	g_pd3dDevice->Release();
	g_StencilView->Release();
	g_TexBuffer->Release();

	VertexBufferStar->Release();
	IndexBufferStar->Release();
	DirectVertShader[0]->Release();
	DirectPixShader[0]->Release();
	DirectInputLay[0]->Release();
	CostantBuffer[0]->Release();
	DirectVertShader[1]->Release();
	DirectPixShader[1]->Release();
	DirectInputLay[1]->Release();
	CostantBuffer[1]->Release();
	CostantPixelBuffer->Release();
}

//************************************************************
//************ WINDOWS RELATED *******************************
//************************************************************

// ****************** BEGIN WARNING ***********************// 
// WINDOWS CODE, I DON'T TEACH THIS YOU MUST KNOW IT ALREADY!
	
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine,	int nCmdShow );						   
LRESULT CALLBACK WndProc(HWND hWnd,	UINT message, WPARAM wparam, LPARAM lparam );		
int WINAPI wWinMain( HINSTANCE hInstance, HINSTANCE, LPTSTR, int )
{
	srand(unsigned int(time(0)));
	DEMO_APP myApp(hInstance,(WNDPROC)WndProc);	
    MSG msg; ZeroMemory( &msg, sizeof( msg ) );
    while ( msg.message != WM_QUIT && myApp.Run() )
    {	
	    if ( PeekMessage( &msg, NULL, 0, 0, PM_REMOVE ) )
        { 
            TranslateMessage( &msg );
            DispatchMessage( &msg ); 
        }
    }
	myApp.ShutDown(); 
	return 0; 
}


LRESULT CALLBACK WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
    if(GetAsyncKeyState(VK_ESCAPE))
		message = WM_DESTROY;
    switch ( message )
    {
        case ( WM_DESTROY ): { PostQuitMessage( 0 ); }
        break;
		case (WM_SIZE) :
		{
						   if (g_pSwapChain)
						   {
							   g_pd3dDeviceContext->OMGetRenderTargets(0, 0, 0);

							   g_pRenderTargetView->Release();

							   g_pSwapChain->ResizeBuffers(0, 0, 0, DXGI_FORMAT_UNKNOWN, 0);

							   ID3D11Texture2D* tempBuffer;
							   g_pSwapChain->GetBuffer(0, __uuidof(ID3D11Texture2D),
								   (void**)&tempBuffer);
								
							   g_pd3dDevice->CreateRenderTargetView(tempBuffer, NULL,
								   &g_pRenderTargetView);

							   tempBuffer->Release();

							   g_pd3dDeviceContext->OMSetRenderTargets(1, &g_pRenderTargetView, NULL);
							  
							   float nWidth = LOWORD(lParam);
							   float nHeight = HIWORD(lParam);

							   // Set up the viewport.
							   D3D11_VIEWPORT vp;
							   vp.Width = nWidth;
							   vp.Height = nHeight;
							   vp.MinDepth = 0.0f;
							   vp.MaxDepth = 1.0f;
							   vp.TopLeftX = 0;
							   vp.TopLeftY = 0;
							   
							   g_pd3dDeviceContext->RSSetViewports(1, &vp);

							   g_TexBuffer->Release();

							   D3D11_TEXTURE2D_DESC texture2D;
							   ZeroMemory(&texture2D, sizeof(texture2D));
							   texture2D.Width = nWidth;
							   texture2D.Height = nHeight;
							   texture2D.Usage = D3D11_USAGE_DEFAULT;
							   texture2D.BindFlags = D3D11_BIND_DEPTH_STENCIL;
							   texture2D.Format = DXGI_FORMAT_D32_FLOAT;
							   texture2D.MipLevels = 1;
							   texture2D.ArraySize = 1;
							   texture2D.SampleDesc.Count = 1;
							   g_pd3dDevice->CreateTexture2D(&texture2D, NULL, &g_TexBuffer);

							   g_StencilView->Release();

							   D3D11_DEPTH_STENCIL_VIEW_DESC stencil;
							   ZeroMemory(&stencil, sizeof(stencil));
							   stencil.Format = DXGI_FORMAT_D32_FLOAT;
							   stencil.ViewDimension = D3D11_DSV_DIMENSION_TEXTURE2DMS;		//use this enum to incorporate sampleDecs.count/.Quality values otherwise use D3D11_DSV_DIMENSION_TEXTURE2D
							   stencil.Texture2D.MipSlice = 0;
							   g_pd3dDevice->CreateDepthStencilView(g_TexBuffer, &stencil, &g_StencilView);

							   g_DirectView.Height = nHeight;
							   g_DirectView.Width = nWidth;
							   
							   g_ScreenChanged = true;
							   //g_newProjection = Projection((nHeight / nWidth), FIELDOFVIEW, ZNEAR, ZFAR);
							   g_newProjection = XMMatrixPerspectiveFovLH(XMConvertToRadians(FIELDOFVIEW), (nWidth/ nHeight), ZNEAR, ZFAR);
						   }
		};
    }
    return DefWindowProc( hWnd, message, wParam, lParam );
}
//********************* END WARNING ************************//