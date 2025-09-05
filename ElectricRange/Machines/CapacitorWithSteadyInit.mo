within ElectricRange.Machines;
model CapacitorWithSteadyInit
  extends Electrification.Machines.Electrical.DC.Capacitor(final v_start_fixed=false, final v_start);
  Electrification.Electrical.DCInit voltageInit(final init_steady=
        v_start_steady)                         annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  parameter Boolean v_start_steady = false "Steady state v_init" annotation (choices(checkBox=true),Dialog(group="Initialization"));
equation
  connect(voltageInit.plug_a, splitter.plug_a) annotation (Line(
      points={{-90,30},{-80,30},{-80,0}},
      color={255,128,0},
      thickness=0.5));
end CapacitorWithSteadyInit;
