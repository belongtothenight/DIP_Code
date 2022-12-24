# Flows

## Flows in train.py

1. Initialize training to generate network evaluation indicators
2. If there is pretrained model
   1. Load checkpoint model
   2. Restore the parameters in the training node to this point
   3. Load checkpoint state dict. Extract the fitted model weights
   4. Overwrite the pretrained model weights to the current model
   5. Load the optimizer model
   6. Load the scheduler model
3. Create a folder of SR experiment results
4. Create training process log file
5. Initialize the gradient scaler
6. Start looping training (mainly used for changing learning-rate based on epoch)
   1. set parameters
   2. train model
   3. validate model
   4. update learning rate
   5. automatically save the model with the highest index
