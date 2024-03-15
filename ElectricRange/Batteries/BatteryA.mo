within ElectricRange.Batteries;
model BatteryA
  extends Electrification.Batteries.Examples.Lumped(
    redeclare Electrification.Batteries.Control.LimitsFixed controller(pMaxIn=200e3,SoC_limits = false),
    fixed_temperature=true,
    ns=100,
    np=1,
    core(
      capacity(Q_cap_cell_nom=180000),
      voltage(vCell_high=4, vCell_low=3)));
end BatteryA;
