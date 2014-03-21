(* Render graphics with V5 front end *)


System`Opacity::usage = 
"Opacity[p] is a graphics directive which specifies that primitives which follow \
are to be drawn with opacity p. Opacity 0 is completely transparent, 1 is completely opaque."


(* Symbols provisionally added to the System contex *)
System`GraphicsColor;
System`Arrow;
System`Inset;
System`GraphicsGroup;
System`CoordinateTransformation;
System`ExpressionBox;
System`Dynamic;
SetAttributes[Dynamic, HoldFirst];


BeginPackage["GraphEdit`"];


SetGraphics::usage =
"SetGraphics[type] sets the type of graphics cells generated by graphics
commands.  \"type\" may be \"SymbolicGraphics\", \"PostScript\", or \"Compare\"";


ResetGraphics::usage =
"ResetGraphics[] restores the display function used before the GraphEdit
package was loaded.";


Begin["`Private`"];


SetGraphics["SymbolicGraphics" | "Symbolic" | "symbolic" | "GraphEdit" | "Graphics" | "graphics" | "G" | "g" | "Direct" | "NSE" | "nse"] :=
        ($DisplayFunction = Identity; $PrePrint =.);
              
SetGraphics["PostScript" | "PS" | "ps"] :=
        ($DisplayFunction = Display[$Display, #, "MPS"]&; 
         $PrePrint := (If[MatchQ[Head[#], (Graphics | Graphics3D | ContourGraphics | DensityGraphics | SurfaceGraphics | GraphicsArray)], 
			"\[SkeletonIndicator] "<>ToString[Head[#]]<>" \[SkeletonIndicator]", #] &)
         );

SetGraphics["Compare"] :=
        ($DisplayFunction = (Display[$Display, #]; #)&;  $PrePrint =.);


If[!ValueQ[$OriginalDisplayFunction],
    $OriginalDisplayFunction = $DisplayFunction;
    $OriginalPrePrint = $PrePrint;
];


ResetGraphics[] := 
   ($DisplayFunction = $OriginalDisplayFunction; $PrePrint = $OriginalPrePrint);



End[];


EndPackage[];


(* If version is 5 or later, automatically SetGraphics *)
If[$ParentLink =!= Null && ToExpression[MathLink`CallFrontEnd@FrontEnd`Value[FrontEnd`$VersionNumber]] < 5.0,
 SetGraphics["PostScript"],
 SetGraphics["SymbolicGraphics"]
];
