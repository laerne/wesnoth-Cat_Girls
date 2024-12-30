#version 330

uniform vec2 uResolution;
uniform float uTime;

out vec4 outColor;

const float sqrt2 = 1.41421356237309504880168872420969807856967187537694807317667973799073247846;
const float sqrt3 = 1.73205080756887729352744634150587236694280525381038062805580697945193301690;
const float sqrt5 = 2.23606797749978969640917366873127623544061835961152572427089724541052092563;
const float cbrt2 = 1.25992104989487316476721060727822835057025146470150798008197511215529967651;
const float cbrt3 = 1.44224957030740838232163831078010958839186925349935057754641619454168759682;
const float cbrt5 = 1.70997594667669698935310887254386010986805511054305492438286170744429592050;

const float sqrt2_inv = 0.70710678118654752440084436210484903928483593768847403658833986899536623923;
const float sqrt3_inv = 0.57735026918962576450914878050195745564760175127012687601860232648397767230;
const float sqrt5_inv = 0.44721359549995793928183473374625524708812367192230514485417944908210418512;
const float cbrt2_inv = 0.79370052598409973737585281963615413019574666394992650490414288091260825281;
const float cbrt3_inv = 0.69336127435063470484335227478596179544593511345775403656586369340003543713;
const float cbrt5_inv = 0.58480354764257321310135747202758455570609972702020600828451470201451211171;

const float halfpi  = 1.57079632679489661923132169163975144209858469968755291048747229615390820314;
const float pi      = 3.14159265358979323846264338327950288419716939937510582097494459230781640628;
const float tau     = 6.28318530717958647692528676655900576839433879875021164194988918461563281257;
const float pi_inv  = 0.31830988618379067153776752674502872406891929148091289749533468811779359526;
const float tau_inv = 0.15915494309189533576888376337251436203445964574045644874766734405889679763;

const float e       = 2.71828182845904523536028747135266249775724709369995957496696762772407663035;
const float phi     = 1.61803398874989484820458683436563811772030917980576286213544862270526046281;

float intervalIndicator(float x, float a, float b)
{
    return float(x >= a && x <= b);
}

float centeredIntervalIndicator(float x, float center, float width)
{
    float halfWidth = width * 0.5f;
    return intervalIndicator(x, center - halfWidth, center + halfWidth);
}

float cubicBump(float x)
{
    float ax = abs(x);
    float xx = ax * ax;
    return 2.f * xx * ax - 3.f * xx + 1.f;
}

float cubicHalfPlateau(float x)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return cubicBump(1.f - x);
}

float cubicHalfPlateau(float x, float slopeStart, float slopeEnd)
{
    return cubicHalfPlateau((x - slopeStart) / (x - slopeEnd));
}

float assymmetricCubicPlateau(
    float x, 
    float leftSupportBound, 
    float rightSupportBound, 
    float leftSlopeDistance, 
    float rightSlopeDitance)
{
    float fromLeftHalfPlateau  = cubicHalfPlateau((x - leftSupportBound)  / leftSlopeDistance);
    float fromRightHalfPlateau = cubicHalfPlateau((rightSupportBound - x) / rightSlopeDitance);

    return min(fromLeftHalfPlateau, fromRightHalfPlateau);
}

const int noEaseFn              = 0;
const int easeInFn              = 1;
const int easeOutFn             = 2;
const int easeInOutFn           = 3;

float _easeIn(float x, float gamma)
{
    return pow(x, gamma);
}

float _easeOut(float x, float gamma)
{
    return 1.f - pow(1.f - x, gamma);
}

// See https://math.stackexchange.com/questions/121720/ease-in-out-function/121755#121755
float _easeInOut(float x, float gamma)
{
    float xGamma = pow(x, gamma);
    return xGamma / (xGamma + pow(1.f - x, gamma));
}

float easeIn(float x, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return _easeIn(x, gamma);
}

float easeOut(float x, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return _easeOut(x, gamma);
}

// See https://math.stackexchange.com/questions/121720/ease-in-out-function/121755#121755
float easeInOut(float x, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    return _easeInOut(x, gamma);
}

float easeInOut2(float x, float alpha, float beta)
{
    return pow(x, alpha) * (1- pow(1-x, beta));
}

float ease(float x, int ease, float gamma)
{
    if (x < 0.f) return 0.f;
    if (x > 1.f) return 1.f;
    switch(ease)
    {
        case noEaseFn:    return x;
        case easeInFn:    return _easeIn(x, gamma);
        case easeOutFn:   return _easeOut(x, gamma);
        case easeInOutFn: return _easeInOut(x, gamma);
    }
    return x;
}

float pulse(
    float x,
    float time,
    float startTime,
    float endTime,
    float fadeInDistance,
    float fadeOutDistance,
    float startWidth,
    float endWidth,
    float fuzzyness,
    int   speedEaseFn,
    float speedGamma
)
{
    float linearRightPos = (time - startTime) / (endTime - startTime);
    float rightPos       = ease(linearRightPos, speedEaseFn, speedGamma);

    float width         = rightPos * endWidth + (1.f - rightPos) * startWidth;
    float halfWidth     = width * 0.5f;
    float pulseValueAtX = assymmetricCubicPlateau(x, rightPos - width, rightPos, fuzzyness, fuzzyness);

    float intensity = assymmetricCubicPlateau(rightPos, 0.f, 1.f, fadeInDistance, fadeOutDistance);
    return pulseValueAtX * intensity;
}

float animation(float x, float t)
{
    float v = 0.f;
    v = max(v, pulse(
        x,
        t,
        0.f, /* startTime */
        3.f, /* endTime */
        0.1f, /* fadeInDistance */
        0.1f, /* fadeOutDistance */
        0.2f, /* startWidth */
        0.125f, /* endWidth */
        0.025f, /* fuzzyness */
        easeOutFn, /* speedEaseFn */
        2.f /* speedGamma */
    ));
    v = max(v, pulse(
        x,
        t,
        0.75f, /* startTime */
        3.75f, /* endTime */
        0.1f, /* fadeInDistance */
        0.1f, /* fadeOutDistance */
        0.2f, /* startWidth */
        0.125f, /* endWidth */
        0.025f, /* fuzzyness */
        easeOutFn, /* speedEaseFn */
        2.f /* speedGamma */
    ));
    v = max(v, pulse(
        x,
        t,
        1.5f, /* startTime */
        4.5f, /* endTime */
        0.1f, /* fadeInDistance */
        0.1f, /* fadeOutDistance */
        0.2f, /* startWidth */
        0.125f, /* endWidth */
        0.025f, /* fuzzyness */
        easeOutFn, /* speedEaseFn */
        2.f /* speedGamma */
    ));

    return v;
}

float fn(float x, float t)
{
    float gamma = pow(8.f, t - 1);
    return easeInOut2(x, gamma, gamma);
}

void main()
{
    // Global display settings
    const float speedFactor = 0.25f;
    const float loopDuration = 3.f;
    const int previewBandThickness = 48;

    // Set the domain interval [a, b] and codomain interval [c, d] to observe here
    float a = 0.f;
    float b = 1.f;
    float c = 0.f;
    float d = 1.f;

    float graphHeight = uResolution.y - previewBandThickness;
    float x = a + gl_FragCoord.x / uResolution.x * b - a;
    float t = uTime * speedFactor;
    if (loopDuration > 0.f)
        t = mod(t, loopDuration);

    // Call your function here, using the following pattern, replacing f by you function name.
    //   vec3 fx = vec3(f(x)); // Non-temporal function to 1D
    //   vec3 fx = f(x); // Non-temporal function to 3D
    //   vec3 fx = vec3(f(x, t)); // temporal function to 1D
    //   vec3 fx = f(x, t); // temporal function to 3D
    vec3 fx = vec3(fn(x, t));
    
    float pixel_y = gl_FragCoord.y;
    vec4 color;
    if (pixel_y > graphHeight)
    {
        color = vec4(fx, 1.f);
    }
    else
    {
        vec3 pixel_fx = graphHeight * (fx - c) / (d - c);
        color.xyz = clamp(pixel_fx - pixel_y, vec3(0.f), vec3(1.f));
        float y = c + pixel_y / graphHeight * (d - c);
        if (y < 0)
            color.xyz = 1.f-color.xyz;
        color.a = max(max(color.r, color.g), color.b);
    }

    outColor = color;
}
