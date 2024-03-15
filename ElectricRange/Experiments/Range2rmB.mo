within ElectricRange.Experiments;
model Range2rmB
  extends Range2(redeclare Machines.MachineB rearMachine);
  annotation (experiment(StopTime=36000, Interval=60));
end Range2rmB;
