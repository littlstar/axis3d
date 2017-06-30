precision mediump float;

//
// Shader dependencies.
//
#pragma glslify: GeometryContext = require('../../geometry/GeometryContext')
#pragma glslify: LightContext = require('../../light/LightContext')
#pragma glslify: Camera = require('../../camera/Camera')
#pragma glslify: Cubemap = require('../Cubemap')
#pragma glslify: Map = require('../Map')

// materials
#pragma glslify: LambertMaterial = require('../LambertMaterial')
#pragma glslify: PhongMaterial = require('../PhongMaterial')
#pragma glslify: FlatMaterial = require('../FlatMaterial')
#pragma glslify: Material = require('../Material')

#pragma glslify: Fog = require('../Fog')

#ifndef MAX_AMBIENT_LIGHTS
#define MAX_AMBIENT_LIGHTS 16
#endif

#ifndef MAX_DIRECTIONAL_LIGHTS
#define MAX_DIRECTIONAL_LIGHTS 16
#endif

#ifndef MAX_POINT_LIGHTS
#define MAX_POINT_LIGHTS 16
#endif

#ifndef MATERIAL_TYPE
#define MATERIAL_TYPE Material
#endif

// default material

#define isinf(n) (n >= 0.0 || n <= 0.0)
#define isnan(n) !isinf(n) && n != n

#define getGeometryContext() GeometryContext(vposition, vnormal, vuv, vLocalPosition, vLocalNormal)

//
// Shader IO.
//
varying vec3 vposition;
varying vec3 vnormal;
varying vec2 vuv;
varying vec3 vLocalPosition;
varying vec3 vLocalNormal;

//
// Shader uniforms.
//
uniform MATERIAL_TYPE material;
uniform LightContext lightContext;
uniform Camera camera;

#ifdef HAS_FOG
uniform Fog fog;
#endif

#ifdef HAS_MAP
uniform Map map;
#elif defined HAS_CUBE_MAP
uniform Cubemap cubemap;
#endif

#ifdef HAS_ENV_MAP
uniform Map envmap;
#elif defined HAS_ENV_CUBE_MAP
uniform Cubemap envcubemap;
#endif


//
// Lambertian shading model.
//
import drawLambertMaterial from './lambert' where {
  MAX_DIRECTIONAL_LIGHTS=MAX_DIRECTIONAL_LIGHTS,
  MAX_AMBIENT_LIGHTS=MAX_AMBIENT_LIGHTS,
  MAX_POINT_LIGHTS=MAX_POINT_LIGHTS,
  getGeometryContext=getGeometryContext,
  lightContext=lightContext,
  material=material,
  envcubemap=envcubemap,
  cubemap=cubemap,
  envmap=envmap,
  map=map,
  camera=camera,
  isnan=isnan,
  isinf=isinf,
  fog=fog
}

//
// Phong shading model.
//
import drawPhongMaterial from './phong' where {
  MAX_DIRECTIONAL_LIGHTS=MAX_DIRECTIONAL_LIGHTS,
  MAX_AMBIENT_LIGHTS=MAX_AMBIENT_LIGHTS,
  MAX_POINT_LIGHTS=MAX_POINT_LIGHTS,
  getGeometryContext=getGeometryContext,
  lightContext=lightContext,
  material=material,
  envcubemap=envcubemap,
  cubemap=cubemap,
  envmap=envmap,
  map=map,
  camera=camera,
  isnan=isnan,
  isinf=isinf,
  fog=fog
}

//
// Flat shading model.
//
import drawFlatMaterial from './flat' where {
  getGeometryContext=getGeometryContext,
  material=material,
  envcubemap=envcubemap,
  cubemap=cubemap,
  envmap=envmap,
  map=map
}

//
// Shader entries.
//
#ifdef useLambertMaterial
void main() {
  drawLambertMaterial();
}
#elif defined usePhongMaterial
void main() {
  drawPhongMaterial();
}
#elif defined useFlatMaterial
void main() {
  drawFlatMaterial();
}
#elif defined SHADER_MAIN_BODY
SHADER_MAIN_BODY_SOURCE
#else
void main() {
  discard;
}
#endif
