build:
	# Info: Running Quartus Prime Analysis & Synthesis
	quartus_map --read_settings_files=on --write_settings_files=off cscb58project -c main
	# Info: Running Quartus Prime Fitter
	quartus_fit --read_settings_files=off --write_settings_files=off cscb58project -c main
	# Info: Running Quartus Prime Assembler
	quartus_asm --read_settings_files=off --write_settings_files=off cscb58project -c main
	# Info: Running Quartus Prime TimeQuest Timing Analyzer
	quartus_sta cscb58project -c main
	# Info: Running Quartus Prime EDA Netlist Writer
	quartus_eda --read_settings_files=off --write_settings_files=off cscb58project -c main
