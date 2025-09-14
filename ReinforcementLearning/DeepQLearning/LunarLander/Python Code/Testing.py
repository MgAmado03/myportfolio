from Training import DQN
import gymnasium as gym
import torch
import matplotlib.pyplot as plt
import numpy as np

env = gym.make("LunarLander-v3", continuous=False, gravity=-10.0,
               enable_wind=False, wind_power=15.0, turbulence_power=1.5)#, render_mode="human")

num_actions = env.action_space.n
states_dim = env.observation_space.shape[0]

trained_net = DQN(states_dim, num_actions) 
trained_net.load_state_dict(torch.load("dqn_lunarlander.pth"))
trained_net.eval()

num_test_episodes = 50
reward_per_test_episode = []

for episode in range(num_test_episodes):
    state, info = env.reset()
    done = False
    truncated = False
    test_episode_reward = 0

    while not (done or truncated):
        state_t = torch.FloatTensor(state).unsqueeze(0)
        final_q_table = trained_net(state_t)
        opt_action = final_q_table.argmax().item()

        next_state, reward, done, truncated, info = env.step(opt_action)

        test_episode_reward += reward
        state = next_state
    
    reward_per_test_episode.append(test_episode_reward)
    print(f"Episode {episode:3d} | Reward: {test_episode_reward:.2f}")

#env.close()

avg_test_reward = np.mean(reward_per_test_episode)

plt.figure(figsize=(10, 5))
plt.plot(range(1, num_test_episodes+1), reward_per_test_episode, label="Reward per episode")
plt.axhline(avg_test_reward, color="red", linestyle="--", label=f"Average reward = {avg_test_reward:.2f}")
plt.xlabel("Episode")
plt.ylabel("Reward")
plt.title("LunarLander DQN Evaluation")
plt.legend()
plt.show()