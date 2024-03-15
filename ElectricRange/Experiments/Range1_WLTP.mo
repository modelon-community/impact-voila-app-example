within ElectricRange.Experiments;
model Range1_WLTP
  extends Range1(driveCycleControl(
    redeclare Electrification.Utilities.DriveCycles.WLTP speedReference));
annotation (
  experiment(StopTime=36000, Interval=60));
end Range1_WLTP;
