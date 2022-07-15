Shader "Sprites/HeatHaze"
{
	Properties
	{
		[NoScaleOffset] _MainTex ("Sprite Texture", 2D) = "white" {}
		_AmplitudeX ("AmplitudeX", range(0, .01)) = 0.006
		_AmplitudeY ("AmplitudeY", range(0, .01)) = 0.001
		_Frequence ("Frequence", range(0, 100)) = 50
		_Speed ("Speed", range(0, 5)) = 2
	}

	SubShader
	{
		Tags
		{
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}

		Blend One OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vertex
			#pragma fragment fragment
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float _AmplitudeX;
			float _AmplitudeY;
			float _Frequence;
			float _Speed;

			struct vertexInput
			{
				float4 vertexLocalPosition : POSITION;
				float2 textureCoordinates : TEXCOORD0;
			};

			struct vertexOutput
			{
				float4 vertexClipSpacePosition : SV_POSITION;
				float2 textureCoordinates : TEXCOORD0;
			};

			vertexOutput vertex (vertexInput input)
			{
				vertexOutput output;
				output.vertexClipSpacePosition = UnityObjectToClipPos(input.vertexLocalPosition);
				output.textureCoordinates = input.textureCoordinates;
				return output;
			}

			float4 fragment (vertexOutput data) : SV_Target
			{
				float offsetX = _AmplitudeX * sin(data.textureCoordinates.x * _Frequence + _Time.y * _Speed);
				float offsetY = _AmplitudeY * sin(data.textureCoordinates.y * _Frequence + _Time.y * _Speed);
				float2 offset = float2(offsetX, offsetY) * smoothstep(0, 1, 1 - data.textureCoordinates.y);
				float4 color = tex2D(_MainTex, data.textureCoordinates + offset);
				color.rgb *= color.a;
				return color;
			}
			ENDCG
		}
	}
}