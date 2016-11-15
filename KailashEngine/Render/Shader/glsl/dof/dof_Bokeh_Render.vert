﻿
layout(location = 0) in vec4 p;

out vec4 v_bokehColor;
out float v_bokehDepth;
out float v_bokehSize;


//layout(binding = 0, offset = 0) uniform atomic_uint bokehCounter;
layout(size4x32, binding = 3) readonly uniform image1D sampler3;
layout(size4x32, binding = 4) readonly uniform image1D sampler4;


uniform float max_bokeh_size = 80.0;
uniform float maxBlur = 80.0;


void main()
{

	// Load bokeh data
	vec4 bokehProperties = imageLoad(sampler3, gl_InstanceID);
	vec4 bokehColor = imageLoad(sampler4, gl_InstanceID);

	// Parse data
	float bokehDepth = bokehProperties.z;
	float objectID = bokehColor.w;
	bokehColor.w = 1.0;
	float coc = bokehProperties.w * maxBlur;
	

	// Bokeh Position
	vec2 pointPosition = 2.0*(bokehProperties.xy-vec2(0.5));
	gl_Position = vec4(pointPosition, 0.0, 1.0);
	
	// Bokeh Size
	float bokehSize = clamp(coc/5.0, 0.0, max_bokeh_size);

	// Bokeh Color
	float cocArea = coc * coc * 3.14159;
	float falloff = pow( (1.0/cocArea) , 0.41);
	vec4 colorMod = bokehColor * falloff;

	v_bokehColor = colorMod;
	v_bokehDepth = bokehDepth;
	v_bokehSize = bokehSize;
}
