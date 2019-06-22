# Kaggle Competition

Robots are smart by design. To fully understand and properly navigate a task, however, they need input about their environment.

In this competition, you’ll help robots recognize the floor surface they’re standing on using data collected from Inertial Measurement Units (IMU sensors).

We’ve collected IMU sensor data while driving a small mobile robot over different floor surfaces on the university premises. The task is to predict which one of the nine floor types (carpet, tiles, concrete) the robot is on using sensor data such as acceleration and velocity. Succeed and you'll help improve the navigation of robots without assistance across many different surfaces, so they won’t fall down on the job.



# Data

## X_[train/test].csv 
the input data, covering 10 sensor channels and 128 measurements per time series plus three ID columns:

- row_id: The ID for this row.

- series_id: ID number for the measurement series. Foreign key to y_train/sample_submission.

- measurement_number: Measurement number within the series.

The orientation channels encode the current angles how the robot is oriented as a quaternion (see Wikipedia). Angular velocity describes the angle and speed of motion, and linear acceleration components describe how the speed is changing at different times. The 10 sensor channels are:

![Capture](https://user-images.githubusercontent.com/46609482/59958553-2f6c3200-945d-11e9-84eb-65a1c6b6a6ed.PNG)


## y_train.csv 
the surfaces for training set.

- series_id: ID number for the measurement series.

- group_id: ID number for all of the measurements taken in a recording session. Provided for the training set only, to enable more cross validation strategies.

- surface: the target for this competition.
