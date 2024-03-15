within ElectricRange.Experiments;
model Range1b_WLTP
  extends Range1b(driveCycleControl(
    redeclare Electrification.Utilities.DriveCycles.WLTP speedReference));
annotation (
  experiment(StopTime=36000, Interval=60));
end Range1b_WLTP;
