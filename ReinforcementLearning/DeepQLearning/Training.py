#region Necessary Imports
import gymnasium as gym

import numpy as np 
import random
import matplotlib
import matplotlib.pyplot as plt
from collections import deque

import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
#endregion



#region Class definition: buffer, DQN 

class ReplayBuffer:

    """
    Initialization: buffer needs a given int capacity

    Methods:
        - store: gets (s,a,r,s') and places it in the buffer
        - sample: gets desired int sample size and returns a random batch of transtitions (s,a,r,s')
        - len: returns the number of transitions stored in the buffer          
    """

    def __init__(self, capacity):
        self.memory = deque([], maxlen=capacity)
    
    def store(self, s, a, r, ns, done):
        self.memory.append((s, a, r, ns, done))

    def sample(self, size):
        return random.sample(self.memory, size)

    def len(self):
        return len(self.memory)

    
class DQN(nn.Module): #gets atributes from nn.Module

    """
    Initialization: 
        - DQN needs size of input and size of output
        - Composed of 1 hidden layer (3 layers total) with 64 inputs and 64 outputs

    Methods:
        - forward: gets input of NN and returns final output
            - no need to call it, it is internally called by calling the NN with an input
    """

    def __init__(self, input_size, output_size):
        super(DQN, self).__init__() #initialized parent class (nn.Module) first 

        self.input_layer = nn.Linear(input_size, 64)
        self.hidden_layer1 = nn.Linear(64, 64)
        self.output_layer = nn.Linear(64, output_size)

    def forward(self, x):
        x = F.relu(self.input_layer(x))
        x = F.relu(self.hidden_layer1(x))
        return self.output_layer(x)

#endregion




#region Hyperparameters
"""
BUFFER_CAPACITY: max number of transitions the buffer can store
BATCH_SIZE: desired number of transitions to sample from the buffer
EPSILON_START: starting value for epsilon
EPSILON_END: final value for epsilon
EPSILON_DECAY: rate of exponential decay for epsilon
TAU: update rate for target NN
LR: same as alpha in mathematical formula, i.e learning rate of the optimizer
GAMMA: time discount factor
NUM_EPISODES: 
MAX_STEPS:
"""
BUFFER_CAPACITY = 10000
BATCH_SIZE = 128
MIN_EXPERIENCES = 2000
EPSILON_START = 1
EPSILON_END = 0.05
LR = 2e-4
GAMMA = 0.98
NUM_EPISODES = 600
TARGET_UPDATE = 1000

#endregion


#region Initializations and function definitions

env = gym.make("LunarLander-v3", continuous=False, gravity=-10.0,
               enable_wind=False, wind_power=15.0, turbulence_power=1.5)#, render_mode="human")

num_actions = env.action_space.n
states_dim = env.observation_space.shape[0]

buffer = ReplayBuffer(BUFFER_CAPACITY)
net = DQN(states_dim, num_actions)
target_net = DQN(states_dim, num_actions)
optimizer = optim.Adam(net.parameters(), lr=LR)


def get_action(neural_net, state, epsilon):
    if random.random() < epsilon:
        return env.action_space.sample()
    else:
        state = torch.FloatTensor(state).unsqueeze(0)
        q_table = neural_net(state)
        return torch.argmax(q_table).item()
    
def SGD(replay_buffer, min_occupied, num_samples, neural_net, target_nn, time_discount):
    if replay_buffer.len() < min_occupied:
        return
    
    sample_batch = replay_buffer.sample(num_samples)
    sample_s, sample_a, sample_r, sample_ns, sample_dones = zip(*sample_batch)
    tsample_s = torch.tensor(np.array(sample_s), dtype=torch.float32)
    tsample_a = torch.tensor(np.array(sample_a), dtype=torch.long)
    tsample_r = torch.tensor(np.array(sample_r), dtype=torch.float32)
    tsample_ns = torch.tensor(np.array(sample_ns), dtype=torch.float32)
    tsample_dones = torch.tensor(np.array(sample_dones), dtype=torch.float32)

    q_table = neural_net(tsample_s) #batch_size x num_actions 
    q_values_estimated = q_table.gather(1, tsample_a.unsqueeze(1)).squeeze(1) #we only want the q values for the actions we took      
    q_target_table =  target_nn(tsample_ns) #batch_size x num_actions

    with torch.no_grad():
        max_next_q = q_target_table.max(1)[0]
    targets = tsample_r + time_discount * max_next_q * (1 - tsample_dones) #when done = sample_r

    loss = nn.MSELoss()(q_values_estimated, targets)
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()


def train(reward_per_episode=[], steps=0):
    for episode in range(NUM_EPISODES):
        done = False
        truncated = False
        episode_reward = 0
        state, info = env.reset()

        while not (done or truncated):

            dynamic_epsilon = max(EPSILON_END, 
                                EPSILON_START - (EPSILON_START - EPSILON_END) * (episode - 1) / (NUM_EPISODES - 1))
            action = get_action(net, state, dynamic_epsilon)
                
            next_state, reward, done, truncated, info = env.step(action)
            buffer.store(state, action, reward, next_state, done)
            state = next_state
            episode_reward += reward
            SGD(buffer, MIN_EXPERIENCES, BATCH_SIZE, net, target_net, GAMMA)
                
            if steps % TARGET_UPDATE == 0:
                target_net.load_state_dict(net.state_dict())
                                            
            steps += 1
        # print(f"Step {steps:3d} | Episode: {episode:.2f}")

        reward_per_episode.append(episode_reward)
        print(f"Episode {episode:3d} | Reward: {episode_reward:.2f}")

    return reward_per_episode

#endregion


#region Calling training functions and plotting

if __name__ == "__main__":

    reward_per_episode = train()
    print("Training complete")
    torch.save(net.state_dict(), "dqn_lunarlander.pth")

    plt.plot(reward_per_episode)
    plt.xlabel('Episode')
    plt.ylabel('Reward')
    plt.title('Lunar Lander')
    plt.show()                    
                       
#endregion














    

