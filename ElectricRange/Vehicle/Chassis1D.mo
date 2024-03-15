within ElectricRange.Vehicle;
model Chassis1D
  Modelica.Mechanics.Rotational.Components.IdealRollingWheel wheels(
    useSupportT=true,
    useSupportR=false,
    radius=wheel_radius) annotation (Placement(transformation(extent={{-60,-70},{-20,-30}})));
  Modelica.Mechanics.Translational.Components.Mass mass(
    m=vehicle_mass, v(start=v_init, fixed=initialize_velocity, displayUnit="m/s")) annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Mechanics.Translational.Components.Fixed fixed annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-70})));
  Modelica.Mechanics.Translational.Components.Damper linearDamper(d=linearDamping) annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Modelon.Mechanics.Translational.QuadraticDamper quadraticDamper(d=
        quadraticDamping)
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Modelica.Mechanics.Translational.Sensors.SpeedSensor speedSensor annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flangeR "Flange of rotational shaft" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,
            -10},{-90,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=J_w, phi(fixed=true,start=0)) annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Electrification.Control.Interfaces.SystemBus controlBus annotation (
      Placement(transformation(extent={{-90,50},{-50,90}}),
        iconTransformation(extent={{-90,50},{-50,90}})));
  Modelica.Mechanics.Translational.Sensors.PositionSensor positionSensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,50})));

  parameter Modelica.Units.SI.Distance wheel_radius=0.3 "Wheel radius";
  parameter Modelica.Units.SI.Mass vehicle_mass=2000 "Vehicle mass";
  parameter Modelica.Units.SI.Inertia J_w = 4 "Moment of inertia of wheels";
  parameter Modelica.Units.SI.Area CdA = 1.0 "Drag area (Cd x A)";
  parameter Modelica.Units.SI.TranslationalDampingConstant linearDamping = 5 "Friction (linear damping constant)";
  parameter Real quadraticDamping(final unit="N.s2/m2") = CdA*airDensity/2 "Drag (quadratic damping constant)";
  constant Modelica.Units.SI.Density airDensity = 1.2 "Air density";

  parameter Boolean initialize_velocity = true annotation(choices(checkBox=true),Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Velocity v_init=0 "Initial velocity of vehicle" annotation(Dialog(enable=initialize_velocity,group="Initialization"));

  parameter Boolean display_name = true "Display the component name in the diagram layer" annotation(Dialog(tab="Conditional"));

  Modelica.Units.SI.Position position = positionSensor.s;
  Modelica.Units.SI.Velocity velocity = speedSensor.v;
protected
  Electrification.Control.Interfaces.ComponentBus chassisSignals
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(mass.flange_a,wheels. flangeT) annotation (Line(points={{0,-50},{-20,-50}},
                                                                                  color={0,127,0}));
  connect(linearDamper.flange_b, fixed.flange) annotation (Line(points={{50,-50},{60,-50},{60,-70}}, color={0,127,0}));
  connect(mass.flange_b, linearDamper.flange_a) annotation (Line(points={{20,-50},{30,-50}}, color={0,127,0}));
  connect(wheels.supportT,fixed. flange) annotation (Line(points={{-20,-70},{60,-70}},                color={0,127,0}));
  connect(speedSensor.flange,mass. flange_a) annotation (Line(points={{-4.44089e-16,
          40},{-4.44089e-16,-50},{0,-50}},            color={0,127,0}));
  connect(inertia.flange_b, wheels.flangeR) annotation (Line(points={{-70,-50},{-60,-50}}, color={0,0,0}));
  connect(inertia.flange_a, flangeR) annotation (Line(points={{-90,-50},{-100,-50},{-100,0}}, color={0,0,0}));
  connect(quadraticDamper.flange_b, fixed.flange) annotation (Line(points={{50,-20},{60,-20},{60,-70}}, color={0,127,0}));
  connect(quadraticDamper.flange_a, mass.flange_b) annotation (Line(points={{30,-20},{20,-20},{20,-50}}, color={0,127,0}));
  connect(positionSensor.flange, mass.flange_a) annotation (Line(points={{-20,40},
          {-20,20},{-4.44089e-16,20},{-4.44089e-16,-50},{0,-50}}, color={0,127,0}));
  connect(speedSensor.v, chassisSignals.velocity) annotation (Line(points={{0,
          61},{0,70},{-50,70}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(positionSensor.s, chassisSignals.position) annotation (Line(
        points={{-20,61},{-20,70},{-50,70}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(chassisSignals, controlBus.chassis) annotation (Line(
      points={{-50,70},{-70,70}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false),
      graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                Bitmap(extent={{-96,-96},{96,96}},   fileName="modelica://Electrification/Resources/Images/vehicle.png"),
        Polygon(
          points={{-84,-28},{84,-28},{58,-66},{-20,-78},{-54,-42},{-84,-28}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{84,-28},{-84,-28}}, color={0,0,0}),
         Rectangle(
          extent={{20,88},{160,60}},
          lineColor={200,196,185},
          fillColor={255,249,235},
          visible=display_name,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{24,86},{156,62}},
          lineColor={100,100,100},
          textString="%name",
          visible=display_name,
          textStyle={TextStyle.Italic})}),
    Diagram(coordinateSystem(
          preserveAspectRatio=false)),Documentation(revisions="<html><!--COPYRIGHT--></html>"));
end Chassis1D;
