if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2025.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/chris/OneDrive/Desktop/Wu-E155-Lab1/lab1_cw_radiant"
if {![file exists {C:/Users/chris/OneDrive/Desktop/Wu-E155-Lab1/lab1_cw_radiant/impl_1}]} {
  file mkdir {C:/Users/chris/OneDrive/Desktop/Wu-E155-Lab1/lab1_cw_radiant/impl_1}
}
cd {C:/Users/chris/OneDrive/Desktop/Wu-E155-Lab1/lab1_cw_radiant/impl_1}
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- lab1_cw_radiant_impl_1.vm lab1_cw_radiant_impl_1.ldc
::radiant::runengine::run_engine_newmsg synthesis -f "C:/Users/chris/OneDrive/Desktop/Wu-E155-Lab1/lab1_cw_radiant/impl_1/lab1_cw_radiant_impl_1_lattice.synproj" -logfile "lab1_cw_radiant_impl_1_lattice.srp"
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o lab1_cw_radiant_impl_1_syn.udb lab1_cw_radiant_impl_1.vm] [list lab1_cw_radiant_impl_1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
