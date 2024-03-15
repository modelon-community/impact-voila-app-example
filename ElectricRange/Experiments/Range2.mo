within ElectricRange.Experiments;
model Range2
  "Maximum acceleration test, with allocation of available power to multiple components."

  extends Modelon.Icons.Experiment;
  replaceable ElectricRange.Machines.MachineA rearMachine constrainedby
    Electrification.Machines.Interfaces.Machine(
    display_name=true,
    enable_thermal_port=false,
    id=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-12,-10})));

  Vehicle.Chassis1D chassis annotation (Placement(transformation(extent={{20,20},{40,40}})));

  ElectricRange.Loads.LoadA auxilaryLoads(
    enable_thermal_port=false,
    display_name=true,
    core(pRef=500),
    thermal(fixed_temperature=true))                             annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  replaceable ElectricRange.Batteries.BatteryA batteryPack(SOC_start=1.0)
    constrainedby Electrification.Batteries.Interfaces.BatteryPack(
    display_name=true,
    enable_thermal_port=false,
    internal_ground=true,
    id=1,
    limitActionSoC=Modelon.Types.FaultAction.Terminate)
    annotation (Placement(transformation(extent={{-40,20},{-60,40}})));
  replaceable ElectricRange.Machines.MachineA frontMachine(electrical(
    v_start_steady=false)) constrainedby
    Electrification.Machines.Interfaces.Machine(
    display_name=true,
    enable_thermal_port=false,
    id=1) annotation (Placement(transformation(extent={{-22,20},{-2,40}})));
  Control.LimitedSpeedControl driveCycleControl(display_name=true,
    machine_ids={frontMachine.id,rearMachine.id},
    battery_id=batteryPack.id)                                                        annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Electrification.Electrical.DCInit vInit(init_steady=true)
    annotation (Placement(transformation(extent={{-62,60},{-42,80}})));
equation
  connect(batteryPack.controlBus, frontMachine.controlBus) annotation (Line(
      points={{-42,40},{-42,46},{-20,46},{-20,40}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(batteryPack.controlBus, chassis.controlBus) annotation (Line(
      points={{-42,40},{-42,46},{23,46},{23,37}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(batteryPack.controlBus, driveCycleControl.controlBus) annotation (
      Line(
      points={{-42,40},{-42,46},{14,46},{14,6},{30,6},{30,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(batteryPack.controlBus, rearMachine.controlBus) annotation (Line(
      points={{-42,40},{-42,46},{14,46},{14,6},{-20,6},{-20,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(batteryPack.controlBus, auxilaryLoads.controlBus) annotation (Line(
      points={{-42,40},{-42,46},{14,46},{14,6},{-58,6},{-58,0}},
      color={240,170,40},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(rearMachine.plug_a, batteryPack.plug_a) annotation (Line(
      points={{-22,-10},{-30,-10},{-30,30},{-40,30}},
      color={255,128,0},
      thickness=0.5));
  connect(frontMachine.plug_a, batteryPack.plug_a) annotation (Line(
      points={{-22,30},{-40,30}},
      color={255,128,0},
      thickness=0.5));
  connect(auxilaryLoads.plug_a, batteryPack.plug_a) annotation (Line(
      points={{-60,-10},{-64,-10},{-64,12},{-30,12},{-30,30},{-40,30}},
      color={255,128,0},
      thickness=0.5));
  connect(chassis.flangeR, frontMachine.flange) annotation (Line(points={{20,30},{-2,30}}, color={0,0,0}));
  connect(rearMachine.flange, chassis.flangeR) annotation (Line(points={{-2,-10},{8,-10},{8,30},{20,30}}, color={0,0,0}));
  connect(vInit.plug_a, batteryPack.plug_a) annotation (Line(
      points={{-42,70},{-30,70},{-30,30},{-40,30}},
      color={255,128,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=36000, Interval=60), Documentation(revisions="<html><hr><p><font class=\"copyright_bold\">Copyright &copy; 2004-2019, MODELON AB</font> <font class=\"copyright_base\">The use of this software component is regulated by the licensing conditions for the Electrification Library. This copyright notice must, unaltered, accompany all components that are derived from, copied from, or by other means have their origin from the Electrification Library. </font></p></html>", info="<html>
<p>This example demonstrates how to allocate available power to multiple components, using the component limits controller functionality.</p>
<h4>Maximum acceleration test</h4>
<p>This is demonstrated with a maximum acceleration test for an electric car. The test is performed by requesting a very large torque, until the velocity threshold is reached. After that, a very large opposite torque is requested until the vehicle comes to a stop. Note that the reference torque (tau_ref) is larger than the actual (limited) torque.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_MaximumPerformance_Velocity.png\"/></p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_MaximumPerformance_Torque.png\"/></p>
<h4>Distributing avaiable power</h4>
<p>A single battery pack is used to power two electric machines and an auxilary load. As opposed to the <a href=\"modelica://Electrification.Examples.BatteryCharging\">BatteryCharging example</a>, the machines and the load cannot be configured to simply listen to the battery limits. If they would each try to use all of the available power, the battery would be overloaded, causing excessive battery current and voltage drop. Instead, a <a href=\"modelica://Electrification.Control.PowerAllocation.Hierarchical\">power allocation controller</a> is used, which listens to the limits reported by the battery controller and explicitly assigns limits to each component.</p>
<p>The power allocation controller applies a hierarchical allocation, where each component in the allocation table is allocated a portion of the power that remains after the component before it. In this example, the front machine is allowed to consume 40 &percnt; of available power (p_rat_in), and is allowed to provide 60 &percnt; of the power allowed into the battery (p_rat_out). The rear machine is allocated 100 &percnt; of what remains, which corresponds to 60 &percnt; and 40 &percnt; respectively. Note that &quot;generous&quot; allocation is used for the rear machine, which means that the load component can use any power not used by the rear machine. The load consumption is also explicitly limited to 50 kW. This means that the rear machine is prioritized. When it use all available power, the load is not allowed to consume any power at all.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_MaximumPerformance_Allocation.png\"/></p>
<p>The result of this allocation is that the combined power consumption of the components stays below the discharge limit of the battery, as shown in the plot below.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_MaximumPerformance_Power.png\"/></p>
<p>The signals shown in the plot above are:</p>
<ul>
<li>battery.summary.pack_p_max_dch</li>
<li>battery.summary.pack_p_out</li>
<li>frontMachine.summary.p_out_mech</li>
<li>rearMachine.summary.p_out_mech</li>
<li>load.core.summary.p_in</li>
</ul>
<p>It is also worth noting that the voltage of the battery drops significantly, but stays high enough to ensure that the battery can deliver power.</p>
<p><img src=\"modelica://Electrification/Resources/Images/Examples/Example_MaximumPerformance_Voltage.png\"/></p>
<h4>Automatically determine available battery power</h4>
<p>The battery controller used in this example is configured to report fixed current and power limits. In addition to this, the controller ensures that the reported discharge limits do not exceed the theoretical available battery power (continuous). The available discharge power is automatically determined based on the voltage and internal resistance of the specific battery pack. This feature is useful for executing a maximum power test like this, without manually determining the power limit. An option to this feature is to rely on the limit assertions in the battery models, to stop the simulation or provide a warning if any battery limits are exceeded.</p>
</html>"));
end Range2;
