within ElectricRange.Machines;
model MachineA
  extends Electrification.Machines.Templates.Machine(
    redeclare Electrification.Machines.Core.Examples.Ideal core(
      redeclare Electrification.Machines.Core.Losses.None lossesMachine,
      redeclare Electrification.Machines.Core.Losses.None lossesConverter,
      controller_limits=true,
      redeclare Electrification.Machines.Core.Limits.Scalar limits(
        I_dc_max_mot=10e3,
        enable_P_max=true,
        tau_max_mot=500)),
    redeclare CapacitorWithSteadyInit electrical,
    redeclare replaceable Electrification.Machines.Mechanical.Gearbox mechanical,
    redeclare replaceable Electrification.Machines.Thermal.MachineConverterLumped thermal,
    redeclare replaceable Electrification.Machines.Control.LimitedTorque controller(
      external_limits=true,
      listen=false,
      redeclare Electrification.Machines.Control.Power torqueControl(external_power=true)),
    display_name=true,
    enable_thermal_port=false,
    fixed_temperature=true);
end MachineA;
