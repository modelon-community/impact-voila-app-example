within ElectricRange.Control;
model LimitedSpeedControl
  extends SpeedControl;

  parameter Integer battery_id = 1 "ID of battery controller";

  Electrification.Control.Limits.GetComponentLimits batteryLimits(
    vMaxSignal=true,
    vMinSignal=true,
    iMaxInSignal=false,
    iMaxOutSignal=false,
    pMaxInSignal=true,
    pMaxOutSignal=true,
    iMaxIn=Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-40}})));
  Electrification.Control.Limits.SetComponentLimits machineLimits[N](each
      i_max_in=Modelica.Constants.inf, each i_max_out=Modelica.Constants.inf)
    annotation (Placement(transformation(extent={{40,-80},{60,-40}})));
  Electrification.Control.Signals.BusSelector batteryBus(category=
        Electrification.Utilities.Types.ControllerType.Battery, id=
        battery_id) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-80,-60})));
  Electrification.Control.Signals.BusSelector machineBus[N](id=machine_ids,
      each category=Electrification.Utilities.Types.ControllerType.Machine)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={80,-60})));
  Modelica.Blocks.Routing.Replicator replicator1(final nout=N)
                                                              annotation (Placement(transformation(extent={{-32,-72},
            {-24,-64}})));
  Modelica.Blocks.Math.Gain gain1[N](k=k)    annotation (Placement(transformation(extent={{-16,-72},
            {-8,-64}})));
  Modelica.Blocks.Math.Gain gain2[N](k=k)    annotation (Placement(transformation(extent={{-16,-84},
            {-8,-76}})));
  Modelica.Blocks.Routing.Replicator replicator2(final nout=N)
                                                              annotation (Placement(transformation(extent={{-32,-84},
            {-24,-76}})));
equation
  for xn in 1:N loop
    connect(machineLimits[xn].v_max, batteryLimits.v_max) annotation (Line(points={{38,-44},{-39,-44}}, color={0,0,127}));
    connect(machineLimits[xn].v_min, batteryLimits.v_min) annotation (Line(points={{38,-50},{-39,-50}}, color={0,0,127}));
    connect(machineBus[xn].systemBus, controlBus) annotation (Line(
      points={{86,-60},{96,-60},{96,100},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  end for;
  connect(batteryBus.componentBus, batteryLimits.componentBus) annotation (
      Line(
      points={{-74,-60},{-70,-60},{-70,-60},{-60,-60}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(batteryBus.systemBus, controlBus) annotation (Line(
      points={{-86,-60},{-96,-60},{-96,100},{0,100}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(machineBus.componentBus, machineLimits.componentBus) annotation (
      Line(
      points={{74,-60},{70,-60},{70,-60},{60,-60}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(gain1.u, replicator1.y) annotation (Line(
      points={{-16.8,-68},{-23.6,-68}},
      color={0,0,127}));
  connect(gain2.u, replicator2.y) annotation (Line(
      points={{-16.8,-80},{-23.6,-80}},
      color={0,0,127}));
  connect(replicator1.u, batteryLimits.p_max_in) annotation (Line(points={{-32.8,-68},{-39,-68}}, color={0,0,127}));
  connect(replicator2.u, batteryLimits.p_max_out) annotation (Line(points={{-32.8,
          -80},{-36,-80},{-36,-74},{-39,-74}}, color={0,0,127}));
  connect(gain1.y, machineLimits.p_max_out) annotation (Line(points={{-7.6,-68},
          {14,-68},{14,-74},{38,-74}}, color={0,0,127}));
  connect(gain2.y, machineLimits.p_max_in) annotation (Line(points={{-7.6,-80},{
          20,-80},{20,-68},{38,-68}}, color={0,0,127}));
end LimitedSpeedControl;
