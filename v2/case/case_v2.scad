include <YAPPgenerator_v17.scad>
//Library used  for Case generation: https://github.com/mrWheel/YAPP_Box/releases/tag/v1.7
//-----------------------------------------------------------------------
// Yet Another Parameterized Projectbox generator
//
//  This is a box for <template>
//
//  Version 1.7 (29-01-2023)
//
// This design is parameterized based on the size of a PCB.
//
//  for many or complex cutoutGrills you might need to adjust
//  the number of elements:
//
//      Preferences->Advanced->Turn of rendering at 100000 elements
//                                                  ^^^^^^
//
//-----------------------------------------------------------------------

// polygonShape = [  [0,0],[20,15],[30,0],[40,15],[70,15]
//                  ,[50,30],[60,45], [40,45],[30,70]
//                  ,[20,45], [0,45]
//                ];

// Note: length/lengte refers to X axis,
//       width/breedte to Y,
//       height/hoogte to Z

/*
            padding-back>|<---- pcb length ---->|<padding-front
                                 RIGHT
                   0    X-ax --->
               +----------------------------------------+   ---
               |                                        |    ^
               |                                        |   padding-right
             ^ |                                        |    v
             | |    -5,y +----------------------+       |   ---
        B    Y |         | 0,y              x,y |       |     ^              F
        A    - |         |                      |       |     |              R
        C    a |         |                      |       |     | pcb width    O
        K    x |         |                      |       |     |              N
               |         | 0,0              x,0 |       |     v              T
               |   -5,0  +----------------------+       |   ---
               |                                        |    padding-left
             0 +----------------------------------------+   ---
               0    X-ax --->
                                 LEFT
*/

printBaseShell = true;
printLidShell = true;

// Edit these parameters for your own board dimensions
wallThickness = 2;
basePlaneThickness = 1;
lidPlaneThickness = 1;

// total height of pcb with esp is approx. 21mm
baseWallHeight = 26;
lidWallHeight = 5;

// ridge where base and lid off box can overlap
// Make sure this isn't less than lidWallHeight
ridgeHeight = 5;
ridgeSlack = 0.2;
roundRadius = 5;

// How much the PCB needs to be raised from the base
// to leave room for solderings and whatnot
standoffHeight = 8.2; // 8; // 5mm battery thickness +  2mm solder pins
pinDiameter = 1.75;   // m2.5?
pinHoleSlack = 0;
standoffDiameter = 5;

// Total height of box = basePlaneThickness + lidPlaneThickness
//                     + baseWallHeight + lidWallHeight
pcbLength = 65.1;
pcbWidth = 53;
pcbThickness = 1.85;

// padding between pcb and inside wall
paddingFront = 1;
paddingBack = 1;
paddingRight = 1;
paddingLeft = 1;

//-- D E B U G -----------------//-> Default ---------
showSideBySide = true; //-> true
onLidGap = 0;
shiftLid = 1;
hideLidWalls = false; //-> false
colorLid = "yellow";
hideBaseWalls = false; //-> false
colorBase = "white";
showOrientation = true;
showPCB = false;
showPCBmarkers = false;
showShellZero = false;
showCenterMarkers = false;
inspectX = 0; //-> 0=none (>0 from front, <0 from back)
inspectY = 0; //-> 0=none (>0 from left, <0 from right)
//-- D E B U G ---------------------------------------

//-- pcb_standoffs  -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = flangeHeight
// (3) = flangeDiameter
// (4) = { yappBoth | yappLidOnly | yappBaseOnly }
// (5) = { yappHole, yappPin }
// (6) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
pcbStands = [
    [ 24, 3, 2, 6, yappBaseOnly, yappHole ],
    [ 24 + 23, 3, 2, 6, yappBaseOnly, yappHole ],
    [ 24, 3 + 47, 2, 6, yappBaseOnly, yappHole ],
    [ 24 + 23, 3 + 47, 2, 6, yappBaseOnly, yappHole ],
];

//-- Lid plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLid = [];

//-- base plane    -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = width
// (3) = length
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsBase =   [
                 //   [10, 10, 20, 10, 45, yappRectangle]
                 // , [30, 10, 15, 10, 45, yappRectangle, yappCenter]
                 // , [20, pcbWidth-20, 15, 0, 0, yappCircle]
                 // , [pcbLength-15, 5, 10, 2, 0, yappCircle]
                ];

//-- front plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsFront = [];

//-- back plane  -- origin is pcb[0,0,0]
// (0) = posy
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
// TODO JST Connectors
cutoutsBack = [
    [ (pcbWidth - 32) / 2, 0, 30, 7, 0, yappRectangle ],
    // [ 11.5, 0, 8, 7, 0, yappRectangle ], // switch
    // [ 2, 11, 25, 8, 0, yappRectangle ], // usb
];

//-- left plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
cutoutsLeft = [];

//-- right plane   -- origin is pcb[0,0,0]
// (0) = posx
// (1) = posz
// (2) = width
// (3) = height
// (4) = angle
// (5) = { yappRectangle | yappCircle }
// (6) = { yappCenter }
// TODO USB and Power Button
cutoutsRight = [
    // [ 11.5, 0, 8, 7, 0, yappRectangle ], // switch
    // [ 2, 11, 25, 8, 0, yappRectangle ],  // usb
    [ 30, -1, 8, 4, 0, yappRectangle ],   // switch
    [ 24, 11, 25, 8, 0, yappRectangle ], // usb
    [ 21, 9, 15, 10, 0, yappRectangle ], // usb
];

//-- cutoutGrills    -- origin is pcb[x0,y0, zx]
// (0) = xPos
// (1) = yPos
// (2) = grillWidth
// (3) = grillLength
// (4) = gWidth
// (5) = gSpace
// (6) = gAngle
// (7) = plane {"base" | "lid" }
// (8) = {polygon points}}
cutoutsGrill = [
                //  [35,  8, 70, 70, 2, 3, 50, "base", polygonShape ]
                // ,[ 0, 20, 10, 40, 2, 3, 50, "lid"]
                // ,[45,  0, 50, 10, 2, 3, 45, "lid"]
                //,[15, 85, 50, 10, 2, 3,  20, "base"]
                //,[85, 15, 10, 50, 2, 3,  45, "lid"]
               ];

//-- connectors
//-- normal         : origen = box[0,0,0]
//-- yappConnWithPCB: origen = pcb[0,0,0]
// (0) = posx
// (1) = posy
// (2) = screwDiameter
// (3) = screwHeadDiameter
// (4) = insertDiameter
// (5) = outsideDiameter
// (6) = flangeHeight
// (7) = flangeDiam
// (8) = { yappConnWithPCB }
// (9) = { yappAllCorners | yappFrontLeft | yappFrondRight | yappBackLeft | yappBackRight }
connectors   =  [
                //     [8, 8, 2.5, 2.8, 3.8, 6, 6, 15, yappAllCorners]
                //   , [15, 10, 2.5, 2.8, 3.5, 6, 5, 11, yappBackLeft, yappBackRight, yappFrontLeft
                //                                     , yappConnWithPCB]
                //   , [10, 6, 2.5, 2.8, 3.5, 6, 5, 11, yappFrontRight, yappConnWithPCB]
              //    , [30, 8, 5, 5, 5]
                ];

//-- base mounts -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = screwDiameter
// (2) = width
// (3) = height
// (4..7) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (5) = { yappCenter }
baseMounts = [
    [ 0, 4, 25, 2, yappBack, yappCenter ], [ 0, 4, 25, 2, yappLeft, yappCenter ], [ 0, 4, 25, 2, yappFront, yappCenter ],
    [ 0, 4, 25, 2, yappRight, yappCenter ]
];

//-- snap Joins -- origen = box[x0,y0]
// (0) = posx | posy
// (1) = width
// (2..5) = yappLeft / yappRight / yappFront / yappBack (one or more)
// (n) = { yappSymmetric }
snapJoins = [
    // [ 0, 10, yappLeft, yappRight, yappSymmetric ],
    [ 0, 10, yappFront, yappBack, yappSymmetric ],
    [ 0, 10, yappBack, yappFront, yappSymmetric ],
    [ 0, 10, yappRight, yappLeft ],
    [ 0, 10, yappLeft, yappRight ],
    [ 50, 10, yappRight, yappLeft ],
];

//-- origin of labels is box [0,0,0]
// (0) = posx
// (1) = posy/z
// (2) = orientation
// (3) = plane {lid | base | left | right | front | back }
// (4) = font
// (5) = size
// (6) = "label text"
// TODO Center
labelsPlane = [
    [ pcbWidth - 10, 18.5, 0, 0.4, "back", "Liberation Mono:style=bold", 3, "4" ],
    [ pcbWidth - 19, 18.5, 0, 0.4, "back", "Liberation Mono:style=bold", 3, "3" ],
    [ pcbWidth - 28, 18.5, 0, 0.4, "back", "Liberation Mono:style=bold", 3, "2" ],
    [ pcbWidth - 37, 18.5, 0, 0.4, "back", "Liberation Mono:style=bold", 3, "1" ],
    // [ 29, 13, 0, 0.4, "back", "Liberation Mono:style=bold", 3, "I" ],
];

//========= MAIN CALL's ===========================================================

//===========================================================
module lidHookInside()
{
    // echo("lidHookInside(original) ..");

} // lidHookInside(dummy)

//===========================================================
module lidHookOutside()
{
    // echo("lidHookOutside(original) ..");

} // lidHookOutside(dummy)

//===========================================================
module baseHookInside()
{
    // echo("baseHookInside(original) ..");

} // baseHookInside(dummy)

//===========================================================
module baseHookOutside()
{
    // echo("baseHookOutside(original) ..");

} // baseHookOutside(dummy)

//---- This is where the magic happens ----
intersection()
{
    // translate([ -.5, 0, 0 ]) cube(size = [ 100, 100, 13 ]);
    YAPPgenerate();
}
// translate([ -29.5, -55.05, standoffHeight + pcbThickness ]) rotate([ 0, 0, 90 ]) import(file = "CollabJam.stl");