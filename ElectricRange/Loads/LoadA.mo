within ElectricRange.Loads;
model LoadA
  extends Electrification.Loads.Examples.ConstantPower(
    enable_control_bus=true,
    fixed_temperature=true);
end LoadA;
