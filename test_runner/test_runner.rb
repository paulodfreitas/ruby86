#require_relative '../sequential/simulator.rb'
require_relative '../pipeline/simulator.rb'

simulator = Simulator.new
simulator.load_file "../test_runner/test.out"
simulator.execute
simulator.print_registers