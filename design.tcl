setDesignMode -process 45

set init_design_netlisttype { Verilog }
set init_verilog { /home/alexmerkulov/tuner/innovus/note_tuner.v }
set init_lef_file {/CMC/kits/GPDK45/gsclib045_all_v4.4/gsclib045_tech/lef/gsclib045_tech.lef /CMC/kits/GPDK45/giolib045_v3.3/lef/giolib045.lef /CMC/kits/GPDK45/gsclib045_all_v4.4/gsclib045/lef/gsclib045_macro.lef}
set init_mmmc_file { /home/alexmerkulov/tuner/innovus/design.view }

set init_pwr_net { VDD! }
set init_gnd_net { VSS! }

setGenerateViaMode -auto true
init_design

floorPlan -site CoreSite -r 1 0.9 1.0 1.0 1.0 1.0

globalNetConnect VDD! -pin VDD -type pgpin
globalNetConnect VSS! -pin VSS -type pgpin

addStripe -nets { VDD! VSS! } -layer Metal11 -direction horizontal -width 1.8 -spacing 4 -set_to_set_distance 10
addStripe -nets { VDD! VSS! } -layer Metal10 -direction vertical -width 1.8 -spacing 4 -set_to_set_distance 10
sroute

setPlaceMode -place_global_place_io_pins true
place_design

set_ccopt_property use_inverters true
set_ccopt_property target_skew 116ps
set_ccopt_property target_max_trans 150ps
ccopt_design

addFiller -cell FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64 -prefix FILL -fitGap
addFiller -cell DECAP2 DECAP3 DECAP4 DECAP5 DECAP6 DECAP7 DECAP8 DECAP9 DECAP10 -prefix DECAP -fitGap

routeDesign

report_timing
addMetalFill -timingAware sta