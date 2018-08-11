simulation_ouput = expand()
trimming_ouput = expand()
rmhost_output = expand()
assembly_output = expand()
prediction_output = expand()
dereplication_output = expand()
profilling_output = expand()

simulation_target = (simulation_output)
trimming_target = (simulation_target + trimming_ouput)
rmhost_target = (trimming_target + rmhost_output)
assembly_target = (rmhost_target + assembly_output)
prediction_target = (assembly_target + prediction_output)
dereplication_target = (prediction_target + dereplication_output)
profilling_target = (dereplication_target + profilling_output)

all_target = (
    simulation_ouput + trimming_ouput + rmhost_output + assembly_output +
    prediction_output + dereplication_output + profilling_output)
