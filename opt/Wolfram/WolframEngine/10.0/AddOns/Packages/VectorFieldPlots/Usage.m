BeginPackage["VectorFieldPlots`"]

If[!ValueQ[GradientFieldPlot3D::usage], GradientFieldPlot3D::usage = "\!\(\*RowBox[{\"GradientFieldPlot3D\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"z\", \"TI\"], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}]}], \"]\"}]\) generates a three-dimensional plot of the gradient vector field of the scalar function \!\(\*StyleBox[\"f\", \"TI\"]\) as a function of \!\(\*StyleBox[\"x\", \"TI\"]\), \!\(\*StyleBox[\"y\", \"TI\"]\) and \!\(\*StyleBox[\"z\", \"TI\"]\).\n\!\(\*RowBox[{\"GradientFieldPlot3D\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dx\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dy\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"z\", \"TI\"], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dz\", \"TI\"]}], \"}\"}]}], \"]\"}]\) uses steps \!\(\*StyleBox[\"dx\", \"TI\"]\), \!\(\*StyleBox[\"dy\", \"TI\"]\) and \!\(\*StyleBox[\"dz\", \"TI\"]\) in variables \!\(\*StyleBox[\"x\", \"TI\"]\), \!\(\*StyleBox[\"y\", \"TI\"]\) and \!\(\*StyleBox[\"z\", \"TI\"]\) respectively."];
If[!ValueQ[GradientFieldPlot::usage], GradientFieldPlot::usage = "\!\(\*RowBox[{\"GradientFieldPlot\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}]}], \"]\"}]\) generates a plot of the gradient vector field of the scalar function \!\(\*StyleBox[\"f\", \"TI\"]\).\n\!\(\*RowBox[{\"GradientFieldPlot\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dx\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dy\", \"TI\"]}], \"}\"}]}], \"]\"}]\) uses steps \!\(\*StyleBox[\"dx\", \"TI\"]\) in variable \!\(\*StyleBox[\"x\", \"TI\"]\), and steps \!\(\*StyleBox[\"dy\", \"TI\"]\) in variable \!\(\*StyleBox[\"y\", \"TI\"]\)."];
If[!ValueQ[HamiltonianFieldPlot::usage], HamiltonianFieldPlot::usage = "\!\(\*RowBox[{\"HamiltonianFieldPlot\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}]}], \"]\"}]\) generates a plot of the Hamiltonian vector field of the scalar-valued function \!\(\*StyleBox[\"f\", \"TI\"]\) as a function of \!\(\*StyleBox[\"x\", \"TI\"]\) and \!\(\*StyleBox[\"y\", \"TI\"]\).\n\!\(\*RowBox[{\"HamiltonianFieldPlot\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dx\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dy\", \"TI\"]}], \"}\"}]}], \"]\"}]\) uses steps \!\(\*StyleBox[\"dx\", \"TI\"]\) in variable \!\(\*StyleBox[\"x\", \"TI\"]\), and steps \!\(\*StyleBox[\"dy\", \"TI\"]\) in variable \!\(\*StyleBox[\"y\", \"TI\"]\)."];
If[!ValueQ[ListVectorFieldPlot3D::usage], ListVectorFieldPlot3D::usage = "\!\(\*RowBox[{\"ListVectorFieldPlot3D\", \"[\", RowBox[{\"{\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"pt\", \"TI\"], StyleBox[\"1\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"vec\", \"TI\"], StyleBox[\"1\", \"TR\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"pt\", \"TI\"], StyleBox[\"2\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"vec\", \"TI\"], StyleBox[\"2\", \"TR\"]]}], \"}\"}], \",\", StyleBox[\"\[Ellipsis]\", \"TR\"]}], \"}\"}], \"]\"}]\) generates a three-dimensional plot of the list of vectors \!\(\*RowBox[{SubscriptBox[StyleBox[\"vec\", \"TI\"], StyleBox[\"1\", \"TR\"]], \",\", \" \", SubscriptBox[StyleBox[\"vec\", \"TI\"], StyleBox[\"2\", \"TR\"]], \",\", \" \", StyleBox[\"\[Ellipsis]\", \"TR\"]}]\), with each vector based at a corresponding point \!\(\*RowBox[{SubscriptBox[StyleBox[\"pt\", \"TI\"], StyleBox[\"1\", \"TR\"]], \",\", \" \", SubscriptBox[StyleBox[\"pt\", \"TI\"], StyleBox[\"2\", \"TR\"]], \",\", \" \", StyleBox[\"\[Ellipsis]\", \"TR\"]}]\)."];
If[!ValueQ[ListVectorFieldPlot::usage], ListVectorFieldPlot::usage = "\!\(\*RowBox[{\"ListVectorFieldPlot\", \"[\", RowBox[{\"{\", RowBox[{RowBox[{\"{\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"11\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"11\", \"TR\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"12\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"12\", \"TR\"]]}], \"}\"}], \",\", StyleBox[\"\[Ellipsis]\", \"TR\"]}], \"}\"}], \",\", StyleBox[\"\[Ellipsis]\", \"TR\"]}], \"}\"}], \"]\"}]\) generates a plot of the vector field corresponding to the array of vectors \!\(\*RowBox[{\"{\", RowBox[{RowBox[{\"{\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"11\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"11\", \"TR\"]]}], \"}\"}], \",\", StyleBox[\"\[Ellipsis]\", \"TR\"]}], \"}\"}], \",\", StyleBox[\"\[Ellipsis]\", \"TR\"]}], \"}\"}]\).\n\!\(\*RowBox[{\"ListVectorFieldPlot\", \"[\", RowBox[{\"{\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"pt\", \"TI\"], StyleBox[\"1\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"vec\", \"TI\"], StyleBox[\"1\", \"TR\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"pt\", \"TI\"], StyleBox[\"2\", \"TR\"]], \",\", SubscriptBox[StyleBox[\"vec\", \"TI\"], StyleBox[\"2\", \"TR\"]]}], \"}\"}], \",\", StyleBox[\"\[Ellipsis]\", \"TR\"]}], \"}\"}], \"]\"}]\) generates a plot of a list of vectors, each based at the corresponding point."];
If[!ValueQ[MaxArrowLength::usage], MaxArrowLength::usage = "MaxArrowLength is an option for the vector field visualization functions that determines the longest vector to be drawn."];
If[!ValueQ[PolyaFieldPlot::usage], PolyaFieldPlot::usage = "\!\(\*RowBox[{\"PolyaFieldPlot\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}]}], \"]\"}]\) generates a plot of the complex-valued function \!\(\*StyleBox[\"f\", \"TI\"]\) in the complex plane using the Polya representation.\n\!\(\*RowBox[{\"PolyaFieldPlot\", \"[\", RowBox[{StyleBox[\"f\", \"TI\"], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dx\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dy\", \"TI\"]}], \"}\"}]}], \"]\"}]\) uses steps \!\(\*StyleBox[\"dx\", \"TI\"]\) in real component \!\(\*StyleBox[\"x\", \"TI\"]\) and steps \!\(\*StyleBox[\"dy\", \"TI\"]\) in imaginary component \!\(\*StyleBox[\"y\", \"TI\"]\)."];
If[!ValueQ[ScaleFactor::usage], ScaleFactor::usage = "ScaleFactor is an option for the vector field visualization functions that scales the vectors so that the longest vector displayed is of the length specified."];
If[!ValueQ[ScaleFunction::usage], ScaleFunction::usage = "ScaleFunction is an option for the vector field visualization functions that rescales each vector to a length determined by applying a pure function to the current length of that vector."];
If[!ValueQ[VectorFieldPlot3D::usage], VectorFieldPlot3D::usage = "\!\(\*RowBox[{\"VectorFieldPlot3D\", \"[\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"x\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"y\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"z\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"z\", \"TI\"], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}]}], \"]\"}]\) generates a three-dimensional plot of the vector field given by the vector-valued function \!\(\*RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"x\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"y\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"z\", \"TI\"]]}], \"}\"}]\) as a function of \!\(\*StyleBox[\"x\", \"TI\"]\) and \!\(\*StyleBox[\"y\", \"TI\"]\) and \!\(\*StyleBox[\"z\", \"TI\"]\).\n\!\(\*RowBox[{\"VectorFieldPlot3D\", \"[\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"x\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"y\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"z\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dx\", \"TI\"]}], \"}\"}], \",\", RowBox[{StyleBox[\"{\", \"TR\"], RowBox[{StyleBox[\"y\", \"TR\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dy\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"z\", \"TI\"], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"z\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dz\", \"TI\"]}], \"}\"}]}], \"]\"}]\) uses steps \!\(\*StyleBox[\"dx\", \"TI\"]\), \!\(\*StyleBox[\"dy\", \"TI\"]\) and \!\(\*StyleBox[\"dz\", \"TI\"]\) for variables \!\(\*StyleBox[\"x\", \"TI\"]\), \!\(\*StyleBox[\"y\", \"TI\"]\) and \!\(\*StyleBox[\"z\", \"TI\"]\) respectively."];
If[!ValueQ[VectorFieldPlot::usage], VectorFieldPlot::usage = "\!\(\*RowBox[{\"VectorFieldPlot\", \"[\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"x\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"y\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]]}], \"}\"}]}], \"]\"}]\) generates a plot of the vector field given by the vector valued function \!\(\*RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"x\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"y\", \"TI\"]]}], \"}\"}]\) as a function of \!\(\*StyleBox[\"x\", \"TI\"]\) and \!\(\*StyleBox[\"y\", \"TI\"]\).\n\!\(\*RowBox[{\"VectorFieldPlot\", \"[\", RowBox[{RowBox[{\"{\", RowBox[{SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"x\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"f\", \"TI\"], StyleBox[\"y\", \"TI\"]]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"x\", \"TI\"], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"x\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dx\", \"TI\"]}], \"}\"}], \",\", RowBox[{\"{\", RowBox[{StyleBox[\"y\", \"TI\"], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"min\", \"TI\"]], \",\", SubscriptBox[StyleBox[\"y\", \"TI\"], StyleBox[\"max\", \"TI\"]], \",\", StyleBox[\"dy\", \"TI\"]}], \"}\"}]}], \"]\"}]\) uses steps \!\(\*StyleBox[\"dx\", \"TI\"]\) in variable \!\(\*StyleBox[\"x\", \"TI\"]\), and steps \!\(\*StyleBox[\"dy\", \"TI\"]\) in variable \!\(\*StyleBox[\"y\", \"TI\"]\)."];
If[!ValueQ[VectorHeads::usage], VectorHeads::usage = "VectorHeads is an option for the three-dimensional vector field functions, including VectorFieldPlot3D, that determines whether the vectors will be displayed with heads. "];

EndPackage[]
