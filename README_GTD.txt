README - GTD ELLA
Authors : Haitham Bou Ammar, Vishnu Purushothaman Sreenivasan modified from Eric Eaton and Paul Ruvolo code under GNU license

I have changed the code to use q functions

Contents

Files 
========

1) addTaskELLA - code similar to Eric's
2) buildInitializeStateLookUpTable - This generates a cell array of starting states for different iteration of learning randomly between the possible limits.

3) doAction - This does the desired action and computes the next state

4) encodeTaskELLARL - This has the GTD(0) algorithm

5) getApproxMap - The RBF file

6) getLegalActions 

7) getTask - This function creates tasks of the type mountain car with different slopes and hence valley regions.

8) GTD - a code to run the ELLA GTD algorithm with a choice of using the L*s as theta or using random initialization for theta

9) getValue - Returns V

10) initModelELLA - same as Eric;s code

11) isTerminal - has the goal been reached

12) next_state_mc - State update

13) plotRL - plot the output for mountain car with various options and parameters

14) reInitializeState - Reset the state for new iteration

15) wrapperScript - THE FINAL TRAIN AND TEST SCRIPT

