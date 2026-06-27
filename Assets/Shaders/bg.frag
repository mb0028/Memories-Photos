#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor;

out vec4 Result;

void main() {
    // vec2 pixel = FlutterFragCoord() / uSize;
    Result = uColor;
}