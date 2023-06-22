package StateSpace
  model testStateSpace
     import Modelica.Utilities.Streams;
     
     parameter Real startTime = 0.01;
     parameter String file11 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S1.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file15 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S2.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file22 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S3.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file24 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S4.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file33 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S5.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file"))); 
      
     parameter String file42 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S6.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file44 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S7.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file51 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S8.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file55 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S9.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String file66 = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S10.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
       
      
     parameter String matrixName_A = "A" "Matrix name in file";
     final parameter Integer dim_A[2] = Modelica.Utilities.Streams.readMatrixSize(file11,matrixName_A) "Dimension of matrix";   
     final parameter Real A11[:,:] = Modelica.Utilities.Streams.readRealMatrix(file11,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";   
     final parameter Real A15[:,:] = Modelica.Utilities.Streams.readRealMatrix(file15,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A22[:,:] = Modelica.Utilities.Streams.readRealMatrix(file22,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A24[:,:] = Modelica.Utilities.Streams.readRealMatrix(file24,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A33[:,:] = Modelica.Utilities.Streams.readRealMatrix(file33,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A42[:,:] = Modelica.Utilities.Streams.readRealMatrix(file42,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A44[:,:] = Modelica.Utilities.Streams.readRealMatrix(file44,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A51[:,:] = Modelica.Utilities.Streams.readRealMatrix(file51,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A55[:,:] = Modelica.Utilities.Streams.readRealMatrix(file55,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     final parameter Real A66[:,:] = Modelica.Utilities.Streams.readRealMatrix(file66,matrixName_A,dim_A[1],dim_A[2]) "Matrix data";
     
     //----------------------------
     
     parameter String matrixName_B = "B" "Matrix name in file";
     final parameter Integer dim_B[2] = Modelica.Utilities.Streams.readMatrixSize(file11,matrixName_B) "Dimension of matrix";   
     final parameter Real B11[:,:] = Modelica.Utilities.Streams.readRealMatrix(file11,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";  
     final parameter Real B15[:,:] = Modelica.Utilities.Streams.readRealMatrix(file15,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B22[:,:] = Modelica.Utilities.Streams.readRealMatrix(file22,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B24[:,:] = Modelica.Utilities.Streams.readRealMatrix(file24,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B33[:,:] = Modelica.Utilities.Streams.readRealMatrix(file33,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B42[:,:] = Modelica.Utilities.Streams.readRealMatrix(file42,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B44[:,:] = Modelica.Utilities.Streams.readRealMatrix(file44,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B51[:,:] = Modelica.Utilities.Streams.readRealMatrix(file51,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B55[:,:] = Modelica.Utilities.Streams.readRealMatrix(file55,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     final parameter Real B66[:,:] = Modelica.Utilities.Streams.readRealMatrix(file66,matrixName_B,dim_B[1],dim_B[2]) "Matrix data";
     
     //----------------------------
     
     parameter String matrixName_C = "C" "Matrix name in file";
     final parameter Integer dim_C[2] = Modelica.Utilities.Streams.readMatrixSize(file11,matrixName_C) "Dimension of matrix";   
     final parameter Real C11[:,:] = Modelica.Utilities.Streams.readRealMatrix(file11,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C15[:,:] = Modelica.Utilities.Streams.readRealMatrix(file15,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C22[:,:] = Modelica.Utilities.Streams.readRealMatrix(file22,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C24[:,:] = Modelica.Utilities.Streams.readRealMatrix(file24,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C33[:,:] = Modelica.Utilities.Streams.readRealMatrix(file33,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C42[:,:] = Modelica.Utilities.Streams.readRealMatrix(file42,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C44[:,:] = Modelica.Utilities.Streams.readRealMatrix(file44,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C51[:,:] = Modelica.Utilities.Streams.readRealMatrix(file51,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C55[:,:] = Modelica.Utilities.Streams.readRealMatrix(file55,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     final parameter Real C66[:,:] = Modelica.Utilities.Streams.readRealMatrix(file66,matrixName_C,dim_C[1],dim_C[2]) "Matrix data";
     
     
    Modelica.Blocks.Continuous.StateSpace stateSpace11(A = A11, B = B11, C = C11) annotation(
      Placement(visible = true, transformation(origin = {-58, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Continuous.StateSpace stateSpace15(A = A15, B = B15, C = C15) annotation(
      Placement(visible = true, transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      //----------------------------
  Modelica.Blocks.Interfaces.RealInput u[3] annotation(
      Placement(visible = true, transformation(origin = {-100, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-96, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
      Placement(visible = true, transformation(origin = {60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //----------------------------
    Modelica.Blocks.Continuous.StateSpace stateSpace22(A = A22, B = B22, C = C22) annotation(
      Placement(visible = true, transformation(origin = {-52, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Continuous.StateSpace stateSpace24(A = A24, B = B24, C = C24) annotation(
      Placement(visible = true, transformation(origin = {6, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.Add add2 annotation(
      Placement(visible = true, transformation(origin = {60, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //----------------------------
  Modelica.Blocks.Continuous.StateSpace stateSpace33(A = A33, B = B33, C = C33) annotation(
      Placement(visible = true, transformation(origin = {-32, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.StateSpace stateSpace42(A = A42, B = B42, C = C42) annotation(
      Placement(visible = true, transformation(origin = {-52, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.StateSpace stateSpace44(A = A44, B = B44, C = C44) annotation(
      Placement(visible = true, transformation(origin = {6, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
      Placement(visible = true, transformation(origin = {60, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.StateSpace stateSpace51 annotation(
      Placement(visible = true, transformation(origin = {-38, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.StateSpace stateSpace55 annotation(
      Placement(visible = true, transformation(origin = {20, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
      Placement(visible = true, transformation(origin = {60, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput u1 annotation(
      Placement(visible = true, transformation(origin = {-100, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-98, -58}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.StateSpace stateSpace66 annotation(
      Placement(visible = true, transformation(origin = {60, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Forces.WorldForceAndTorque forceAndTorque annotation(
      Placement(visible = true, transformation(origin = {146, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1 annotation(
      Placement(visible = true, transformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2 annotation(
      Placement(visible = true, transformation(origin = {100, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3 annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4 annotation(
      Placement(visible = true, transformation(origin = {100, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain5 annotation(
      Placement(visible = true, transformation(origin = {100, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain6 annotation(
      Placement(visible = true, transformation(origin = {100, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b annotation(
      Placement(visible = true, transformation(origin = {194, -2}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  equation
    connect(stateSpace11.y, add1.u1) annotation(
      Line(points = {{-46, 70}, {46, 70}, {46, 76}, {48, 76}}, color = {0, 0, 127}));
  connect(stateSpace15.y, add1.u2) annotation(
      Line(points = {{12, 70}, {46, 70}, {46, 64}, {48, 64}}, color = {0, 0, 127}));
  connect(stateSpace22.y, add2.u1) annotation(
      Line(points = {{-40, 34}, {46, 34}, {46, 40}, {48, 40}}, color = {0, 0, 127}));
  connect(stateSpace24.y, add2.u2) annotation(
      Line(points = {{18, 34}, {48, 34}, {48, 28}, {48, 28}}, color = {0, 0, 127}));
  connect(u[1], stateSpace11.u[1]) annotation(
      Line(points = {{-100, 18}, {-72, 18}, {-72, 70}, {-70, 70}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u[1], stateSpace15.u[1]) annotation(
      Line(points = {{-100, 18}, {-14, 18}, {-14, 70}, {-12, 70}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u[2], stateSpace22.u[1]) annotation(
      Line(points = {{-100, 18}, {-66, 18}, {-66, 34}, {-64, 34}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u[2], stateSpace24.u[1]) annotation(
      Line(points = {{-100, 18}, {-6, 18}, {-6, 34}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u[3], stateSpace33.u[1]) annotation(
      Line(points = {{-100, 18}, {-44, 18}, {-44, -4}}, color = {0, 0, 127}, thickness = 0.5));
  connect(stateSpace42.y[1], add3.u1) annotation(
      Line(points = {{-40, -36}, {46, -36}, {46, -30}, {48, -30}}, color = {0, 0, 127}));
  connect(stateSpace44.y[1], add3.u2) annotation(
      Line(points = {{18, -36}, {46, -36}, {46, -42}, {48, -42}}, color = {0, 0, 127}));
  connect(stateSpace51.y[1], add4.u1) annotation(
      Line(points = {{-26, -68}, {48, -68}, {48, -62}, {48, -62}}, color = {0, 0, 127}));
  connect(stateSpace55.y[1], add4.u2) annotation(
      Line(points = {{32, -68}, {46, -68}, {46, -74}, {48, -74}}, color = {0, 0, 127}));
  connect(u1[1], stateSpace42.u[1]) annotation(
      Line(points = {{-100, -50}, {-66, -50}, {-66, -36}, {-64, -36}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u1[1], stateSpace44.u[1]) annotation(
      Line(points = {{-100, -50}, {-6, -50}, {-6, -36}, {-6, -36}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u1[2], stateSpace51.u[1]) annotation(
      Line(points = {{-100, -50}, {-50, -50}, {-50, -68}, {-50, -68}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u1[2], stateSpace55.u[1]) annotation(
      Line(points = {{-100, -50}, {6, -50}, {6, -68}, {8, -68}}, color = {0, 0, 127}, thickness = 0.5));
  connect(u1[3], stateSpace66.u[1]) annotation(
      Line(points = {{-100, -50}, {-74, -50}, {-74, -100}, {48, -100}, {48, -100}}, color = {0, 0, 127}, thickness = 0.5));
  connect(add1.y, gain1.u) annotation(
      Line(points = {{72, 70}, {88, 70}, {88, 70}, {88, 70}}, color = {0, 0, 127}));
  connect(add3.y, gain4.u) annotation(
      Line(points = {{72, -36}, {86, -36}, {86, -36}, {88, -36}}, color = {0, 0, 127}));
  connect(add4.y, gain5.u) annotation(
      Line(points = {{72, -68}, {86, -68}, {86, -72}, {88, -72}}, color = {0, 0, 127}));
  connect(stateSpace66.y[1], gain6.u) annotation(
      Line(points = {{72, -100}, {88, -100}, {88, -106}, {88, -106}}, color = {0, 0, 127}));
  connect(gain1.y, forceAndTorque.force[1]) annotation(
      Line(points = {{112, 70}, {134, 70}, {134, 10}, {134, 10}}, color = {0, 0, 127}));
  connect(add2.y, gain2.u) annotation(
      Line(points = {{72, 34}, {86, 34}, {86, 34}, {88, 34}}, color = {0, 0, 127}));
  connect(gain2.y, forceAndTorque.force[2]) annotation(
      Line(points = {{112, 34}, {134, 34}, {134, 10}, {134, 10}}, color = {0, 0, 127}));
  connect(stateSpace33.y[1], gain3.u) annotation(
      Line(points = {{-20, -4}, {88, -4}, {88, 0}, {88, 0}}, color = {0, 0, 127}));
  connect(gain3.y, forceAndTorque.force[3]) annotation(
      Line(points = {{112, 0}, {134, 0}, {134, 10}, {134, 10}}, color = {0, 0, 127}));
  connect(gain4.y, forceAndTorque.torque[1]) annotation(
      Line(points = {{112, -36}, {132, -36}, {132, 22}, {134, 22}}, color = {0, 0, 127}));
  connect(gain5.y, forceAndTorque.torque[2]) annotation(
      Line(points = {{112, -72}, {132, -72}, {132, 22}, {134, 22}}, color = {0, 0, 127}));
  connect(gain6.y, forceAndTorque.torque[3]) annotation(
      Line(points = {{112, -106}, {132, -106}, {132, 22}, {134, 22}}, color = {0, 0, 127}));
  connect(forceAndTorque.frame_b, frame_b) annotation(
      Line(points = {{156, 16}, {194, 16}, {194, -2}, {194, -2}}, color = {95, 95, 95}));
  annotation(
      Icon(graphics = {Text(origin = {0, 4}, extent = {{-74, 34}, {74, -34}}, textString = "retardation")}));end testStateSpace;

  model testTables
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
      Placement(visible = true, transformation(origin = {-70, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 1) annotation(
      Placement(visible = true, transformation(origin = {-70, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable2D combiTable2D1(fileName = "F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/A2.mat", tableName = "A", tableOnFile = true)  annotation(
      Placement(visible = true, transformation(origin = {-2, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(const.y, combiTable2D1.u1) annotation(
      Line(points = {{-58, 48}, {-14, 48}, {-14, 36}, {-14, 36}}, color = {0, 0, 127}));
  connect(const1.y, combiTable2D1.u2) annotation(
      Line(points = {{-58, 8}, {-16, 8}, {-16, 24}, {-14, 24}}, color = {0, 0, 127}));
  end testTables;

  model readFile
     import Modelica.Utilities.Streams;
     parameter String file = Modelica.Utilities.Files.loadResource("F:/JG_new/FAST_New_Programing/matlabtool/statespace_replace_covolution/S1.mat") "File name of matrix"
      annotation(Dialog(loadSelector(filter="MATLAB MAT files (*.mat)", caption="Open MATLAB MAT file")));
      
     parameter String matrixName = "A" "Matrix name in file";
     final parameter Integer dim[2] = Modelica.Utilities.Streams.readMatrixSize(file,matrixName) "Dimension of matrix";
     
     final parameter Real A[:,:] = Modelica.Utilities.Streams.readRealMatrix(file,matrixName,dim[1],dim[2]) "Matrix data";
     
     
     
  equation

  end readFile;

  function readRealParameter
  extends Modelica.Icons.Function;
    input String fileName "Name of file" annotation(
      Dialog(loadSelector(filter = "Text files (*.txt)", caption = "Open file in which Real parameters are present")));
    input String name "Name of parameter";
    output Real result "Actual value of parameter on file";
  end readRealParameter;
  annotation(
    uses(Modelica(version = "3.2.3")));
end StateSpace;
