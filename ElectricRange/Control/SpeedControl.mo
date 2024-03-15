within ElectricRange.Control;
model SpeedControl
  extends Electrification.Control.Interfaces.BaseController(final id);
  replaceable Electrification.Utilities.DriveCycles.NEDC speedReference
  constrainedby Electrification.Utilities.DriveCycles.Template(repeat=true) annotation (Placement(
        transformation(extent={{-60,0},{-40,20}})), choicesAllMatching=true);
  parameter Boolean display_name = true "Display the component name in the diagram layer" annotation(Dialog(tab="Conditional"));
  parameter Integer machine_ids[:] = {1} "IDs of each machine controller";
  parameter Real k[N]=ones(N)/N "Power ratio of each machine";
  Modelon.Blocks.Control.LimPID speedController(
    yMax=100e3,
    Td=0.1,
    k=100e3,
    Ti=5,
    Ni=0.1,
    initType=Modelica.Blocks.Types.Init.NoInit) annotation (Placement(transformation(extent={{-30,0},
            {-10,20}})));
  Electrification.Machines.Control.Signals.pwr_ref powerCommand[N](id=
        machine_ids) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={50,10})));
  Modelica.Blocks.Routing.Replicator replicator(final nout=N) annotation (Placement(transformation(extent={{4,4},{
            16,16}})));
  Modelica.Blocks.Math.Gain gain[N](k=k)     annotation (Placement(transformation(extent={{24,4},{36,16}})));
  final parameter Integer N = size(machine_ids,1) "Number of electric machines";
protected
  Electrification.Control.Interfaces.ComponentBus chassisSignals
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
equation
  connect(chassisSignals, controlBus.chassis) annotation (Line(
      points={{0,70},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(speedReference.y,speedController. u_s) annotation (Line(points={{-39,10},
          {-32,10}},                                                                          color={0,0,127}));
  connect(speedController.u_m, chassisSignals.velocity) annotation (Line(points={{-20,-2},
          {-20,-10},{-70,-10},{-70,30},{0,30},{0,70}},
                                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  for xb in 1:N loop
    connect(powerCommand[xb].systemBus, controlBus) annotation (Line(
        points={{54,10},{70,10},{70,100},{0,100}},
        color={240,170,40},
        pattern=LinePattern.Dot,
        thickness=0.5));
  end for;
  connect(speedController.y, replicator.u) annotation (Line(points={{-9,10},{2.8,
          10}},                                                                         color={0,0,127}));
  connect(gain.u, replicator.y) annotation (Line(points={{22.8,10},{16.6,10}}, color={0,0,127}));
  connect(gain.y, powerCommand.u_r) annotation (Line(points={{36.6,10},{44,10},{44,10},{44,10}},
                                                 color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
         Rectangle(
          extent={{-20,80},{160,52}},
          lineColor={200,196,185},
          fillColor={255,249,235},
          visible=display_name,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-16,78},{156,54}},
          lineColor={100,100,100},
          textString="%name",
          visible=display_name,
          textStyle={TextStyle.Italic})}));
end SpeedControl;
