**Intro**
Author: Margarida Amado
Lunar Lander consists of a simulation where a spacecraft must land
safely on a landing pad on the moon and here a Deep Q-learning solution
is presented.

**Environment Info**
There are two possible action spaces that can be used - one discrete and
one continuous. With the goal of using the Deep Q-learning algorithm,
the discrete version was chosen.
More information about this environment can be found in Gymnasium’s
documentation
(https://gymnasium.farama.org/environments/box2d/lunar_lander/).

**Folder Organisation**
	(1) Python Code:
		- Contains the code used to train the neural network (Training.py)
		- Contains the code used to test the neural network using 50 episodes(Testing.py)
	(2) Results:
		- Contains the final neural network (dqn_lunarlander.pth)
		- Contains two plots:
			a) Reward per episode and Average Reward during testing (dqn_evaluation.png)
			b) Reward per episode during training (training_process.png)
		- Example Video of a successful solution (Success-ExampleVideo.mov)

**Additional Info**
- Each run of “Training.py” produces a different neural network.
- Each run of “Testing.py” may yield different results, even with the
same neural network.
- Therefore, it is not realistic to expect the average reward to always
exceed 200. Thus, the goal was defined as ensure an average reward >= 50
during testing.
