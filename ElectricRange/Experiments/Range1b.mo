within ElectricRange.Experiments;
model Range1b
  extends Range1(redeclare Batteries.BatteryB batteryPack);
annotation (
  experiment(StopTime=36000, Interval=60));
end Range1b;
