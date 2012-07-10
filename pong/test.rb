require_relative "../sequential/simulator"

simulator = Simulator.new
simulator.load_file "paint.out"

simulator.run

#puts "wait for a kill"
#gets

#simulator.dump 0x90000
#simulator.dump 0x9000A
#simulator.dump 0x90014