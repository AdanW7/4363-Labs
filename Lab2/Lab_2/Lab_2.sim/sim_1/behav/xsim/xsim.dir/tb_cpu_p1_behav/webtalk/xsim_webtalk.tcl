webtalk_init -webtalk_dir /home/wodzi003/Downloads/Lab_2/Lab_2.sim/sim_1/behav/xsim/xsim.dir/tb_cpu_p1_behav/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Mon Nov 13 04:15:05 2023" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "XSIM v2020.2 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "3064766" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "LIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "xsim_vivado" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "2845716a-70d6-4993-81c9-3aa81ba386bc" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "893f4b6fbb534e04a6c8ef5a982e898b" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "32" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Ubuntu" -context "user_environment"
webtalk_add_data -client project -key os_release -value "Ubuntu 20.04.6 LTS" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Xeon(R) CPU E5-2699 v4 @ 2.20GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "2199.998 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "6" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "67.000 GB" -context "user_environment"
webtalk_register_client -client xsim
webtalk_add_data -client xsim -key Command -value "xsim" -context "xsim\\command_line_options"
webtalk_add_data -client xsim -key trace_waveform -value "true" -context "xsim\\usage"
webtalk_add_data -client xsim -key runtime -value "2200 ns" -context "xsim\\usage"
webtalk_add_data -client xsim -key iteration -value "0" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Time -value "0.02_sec" -context "xsim\\usage"
webtalk_add_data -client xsim -key Simulation_Memory -value "124384_KB" -context "xsim\\usage"
webtalk_transmit -clientid 568982311 -regid "" -xml /home/wodzi003/Downloads/Lab_2/Lab_2.sim/sim_1/behav/xsim/xsim.dir/tb_cpu_p1_behav/webtalk/usage_statistics_ext_xsim.xml -html /home/wodzi003/Downloads/Lab_2/Lab_2.sim/sim_1/behav/xsim/xsim.dir/tb_cpu_p1_behav/webtalk/usage_statistics_ext_xsim.html -wdm /home/wodzi003/Downloads/Lab_2/Lab_2.sim/sim_1/behav/xsim/xsim.dir/tb_cpu_p1_behav/webtalk/usage_statistics_ext_xsim.wdm -intro "<H3>XSIM Usage Report</H3><BR>"
webtalk_terminate
