## simple_simulation.jl
##
## Author: Taylor Kessinger <tkess@sas.upenn.edu>
## Simulates a population of agents for a fixed gossip length.
## Iterates the processes of gameplay, view updating, gossip, and strategy updating
## for a fixed number of generations.
## Plots useful quantities.

using Revise
using Statistics
import PyPlot as plt

# Import custom module
includet("NeutralGossip.jl")
using .NeutralGossip

N = 50 # population size
glen = floor(Int64,0.2*N^3) # number of gossip events between action/view update
simlen = 10000 # number of generations to simulate

# Initialize population
# The social norm is Stern Judging
sp = SimParams(N,5.0,1.0,0.02,0.0,1.0,0.00, BitMatrix([1 0; 0 1]), [ BitVector([0,1]) ])
pop = Population(N)
gp = GossipParams(glen)


# Simulate evolution
for i in 1:simlen
    evolve!(pop,sp,gp)
end

gens_to_skip = 10

h = mean(hcat(pop.views_history...)[1,:])
print(h)

# Plot average reputation of each strategy over time
plt.figure()
plt.plot(1:gens_to_skip:simlen,hcat(pop.views_history...)[1,1:2*gens_to_skip:end],label="ALLD",color="#FF42A1")
plt.ylim(0,1)
plt.title("average view (reputation)")
plt.legend(loc=2)

plt.show()