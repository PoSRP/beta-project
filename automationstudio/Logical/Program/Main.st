
PROGRAM _INIT
	
	// Start in local mode with experior sim
	hmi.buttons.start := TRUE;
	hmi.buttons.experiorSim := TRUE;
	hmi.buttons.localPid := TRUE;
	
END_PROGRAM

PROGRAM _CYCLIC
	// 1. BUTTON LOGIC
	// 2. SIMULATION READS
	// 3. STATE SWITCH
	// 	3.1 HOMING
	//	3.2 SEEK TO MID
	//	3.3 CONTROL LOOP MODE
	// 4. SIMULATION WRITES
	// 5. HMI
	
	//////////////////
	// BUTTON LOGIC //
	//////////////////
	// Experior simulation button
	IF hmi.buttons.experiorSim AND NOT hmi.buttons.experiorSimPrevious THEN
		// Mode switched to experior sim
		hmi.buttons.experiorSimPrevious := hmi.buttons.experiorSim;
		hmi.buttons.simulinkSim := NOT hmi.buttons.experiorSim;
		hmi.buttons.simulinkSimPrevious := NOT hmi.buttons.experiorSim;
	ELSIF NOT hmi.buttons.experiorSim AND hmi.buttons.experiorSimPrevious THEN
		// Switched off
		hmi.buttons.experiorSimPrevious := hmi.buttons.experiorSim;
	END_IF	
	
	// Simulink simulation button
	IF hmi.buttons.simulinkSim AND NOT hmi.buttons.simulinkSimPrevious THEN
		// Mode switched to simulink sim
		hmi.buttons.simulinkSimPrevious := hmi.buttons.simulinkSim;
		hmi.buttons.experiorSim := NOT hmi.buttons.simulinkSim;
		hmi.buttons.experiorSimPrevious := NOT hmi.buttons.simulinkSim;
	ELSIF NOT hmi.buttons.simulinkSim AND hmi.buttons.simulinkSimPrevious THEN
		// Switched off
		hmi.buttons.simulinkSimPrevious := hmi.buttons.simulinkSim;
	END_IF
	
	// Local control button
	IF hmi.buttons.localPid AND NOT hmi.buttons.localPidPrevious THEN
		// Mode switched to local PID
		hmi.buttons.localPidPrevious := hmi.buttons.localPid;
		hmi.buttons.simulinkPid := NOT hmi.buttons.localPid;
		hmi.buttons.simulinkPidPrevious := NOT hmi.buttons.localPid;
	ELSIF NOT hmi.buttons.localPid AND hmi.buttons.localPidPrevious THEN
		// Switched off
		hmi.buttons.localPidPrevious := hmi.buttons.localPid;
	END_IF	
	
	// Simulink control button
	IF hmi.buttons.simulinkPid AND NOT hmi.buttons.simulinkPidPrevious THEN
		// Mode switched to simulink PID
		hmi.buttons.simulinkPidPrevious := hmi.buttons.simulinkPid;
		hmi.buttons.localPid := NOT hmi.buttons.simulinkPid;
		hmi.buttons.localPidPrevious := NOT hmi.buttons.simulinkPid;
	ELSIF NOT hmi.buttons.simulinkPid AND hmi.buttons.simulinkPidPrevious THEN
		// Switched off
		hmi.buttons.simulinkPidPrevious := hmi.buttons.simulinkPid;
	END_IF 
	
	// Button logic for start button
	IF hmi.buttons.start AND NOT hmi.buttons.startPrevious THEN
		// Mode switched to ON
		hmi.buttons.startPrevious := hmi.buttons.start;
	ELSIF NOT hmi.buttons.start AND hmi.buttons.startPrevious THEN
		// Switched off
		hmi.buttons.startPrevious := hmi.buttons.start;
	END_IF	
	//////////////////////
	// BUTTON LOGIC END //
	//////////////////////
	
	
	//////////////////////
	// SIMULATION READS //
	//////////////////////
	// Update the current values through either pvi or opcua, based on button states
	IF hmi.buttons.experiorSim THEN
		
		control.currentAngle := DINT_TO_REAL(pvi.pendulumAngle);
		control.currentPosition := DINT_TO_REAL(pvi.cartPositionEncoder) / 1000;
		// Remap angle so that 0 is vertical and signed, in radians
		control.currentAngle := (DINT_TO_REAL(pvi.pendulumAngle)) * 2 * 3.14159 / 1024.0;
		IF control.currentAngle > 3.14159 THEN
			control.currentAngle := control.currentAngle - 2 * 3.14159;
		END_IF
		// Flip it
		control.currentAngle := -control.currentAngle;
		
		// And direction, velocity is just signed
		IF control.currentVelocity >= 0 THEN
			control.currentDirection := TRUE;
		ELSE
			control.currentDirection := FALSE;
		END_IF
		
	ELSIF hmi.buttons.simulinkSim THEN
		// Same stuff, but for simulink
		control.currentAngle := opcua.pendulumAngle;
		control.currentPosition := opcua.cartPosition;
		control.currentVelocity := opcua.cartVelocity;
		IF control.currentVelocity >= 0 THEN
			control.currentDirection := TRUE;
		ELSE
			control.currentDirection := FALSE;
		END_IF
		
	ELSE
		// No simulation is chosen, zero out
		control.currentAngle := 0;
		control.currentPosition := 0;
		control.currentVelocity := 0;
		control.currentDirection := FALSE;
		
	END_IF
	/////////////////////////
	// SIMULATION READ END //
	/////////////////////////
	
	
	//////////////////
	// STATE SWITCH //
	//////////////////
	CASE control.state OF 
		CTRL_INIT:
			// Hmm ...
			//control.state := CTRL_HOME_START;
			control.state := CTRL_RUNNING;
			
			lqr.x[1] := 0;
			lqr.x[2] := 0;
			lqr.x[3] := 0;
			lqr.x[4] := 0;
			lqr.xn := lqr.x;
			lqr.intOut := lqr.x;
			lqr.intSave := lqr.x;
			lqr.u := 0;
			
		CTRL_HOME_START:
			// There's only homing for Experior
			// Matlab gets a set of default values
			IF hmi.buttons.experiorSim THEN
				control.state := CTRL_HOME_SEEK_NEG;
			ELSIF hmi.buttons.simulinkSim THEN
				control.state := CTRL_STOP;
			END_IF
			
		CTRL_HOME_SEEK_NEG:
			// Seek the negative limit switch
			IF hmi.buttons.experiorSim THEN
				control.setVelocity := -control.homing.seekVelocity;
				IF pvi.motor.isMin THEN
					control.homing.foundNegLim := control.currentPosition;
					control.state := CTRL_HOME_SEEK_POS;
				END_IF
	
			ELSIF hmi.buttons.simulinkSim THEN
				// TODO: Implement some homing for simulink
				control.state := CTRL_STOP;
			
			ELSE
				// No sim, wat do
				control.state := CTRL_NO_SIM;
				
			END_IF;
			
			
		CTRL_HOME_SEEK_POS:
			// Seek the positive limit switch
			IF hmi.buttons.experiorSim THEN
				control.setVelocity := control.homing.seekVelocity;
				IF pvi.motor.isMax THEN
					control.homing.foundPosLim := control.currentPosition;
					control.state := CTRL_HOME_CENTER;
				END_IF
	
			ELSIF hmi.buttons.simulinkSim THEN
				// TODO: Implement some homing for simulink
				control.state := CTRL_STOP;
			
			ELSE
				// No sim, wat do
				control.state := CTRL_NO_SIM;
				
			END_IF;
			
		CTRL_HOME_CENTER:
			// Move to the center position to prep for start
			IF hmi.buttons.experiorSim THEN
				control.setVelocity := -control.homing.middleVelocity;
				IF pvi.motor.isMiddle OR ((control.homing.foundNegLim + control.homing.foundPosLim)/2 >= control.currentPosition) THEN
					control.state := CTRL_STOP;
				END_IF
	
			ELSIF hmi.buttons.simulinkSim THEN
				// TODO: Implement some homing for simulink
				control.state := CTRL_STOP;
			
			ELSE
				// No sim, wat do
				control.state := CTRL_NO_SIM;
				
			END_IF;
			
		CTRL_STOP:
			// Wait here until started
			control.setVelocity := 0;
			IF hmi.buttons.start THEN
				control.state := CTRL_RUNNING;
			END_IF
			
		CTRL_RUNNING:
			// Check if no longer started
			IF NOT hmi.buttons.start THEN
				control.state := CTRL_STOP;
				
			ELSE
				//////////////////
				// CONTROL LOOP //
				//////////////////
				IF hmi.buttons.localPid THEN
					// This is where the local control can be calculated
					// The calculated velocity is set through control.setVelocity
					
					//lqr.x[1] := lqr.x[1] - control.setPosition;
					//lqr.x[2];  
					//lqr.x[3] := lqr.x[3] - control.setAngle;
					//lqr.x[4]];

					lqr.u := lqr.Klqr[1] * (lqr.x[1] - control.setPosition) + lqr.Klqr[2] * lqr.x[2] + lqr.Klqr[3] * (lqr.x[3] - control.setAngle) + lqr.Klqr[4] * lqr.x[4];
					
					control.setVelocity := LREAL_TO_REAL(lqr.u * (1 / (lqr.mc + lqr.mp)) * lqr.Ts) * 1000;
					
					lqr.xn[1] := lqr.B[1] * lqr.u + lqr.A[1,1] * lqr.x[1] + lqr.A[1,2] * lqr.x[2] + lqr.A[1,3] * lqr.x[3] + lqr.A[1,4] * lqr.x[4] + lqr.Kf[1,2] * (lqr.x[3] - control.currentAngle) + lqr.Kf[1,1] * (lqr.x[1] - control.currentPosition);
					lqr.xn[2] := lqr.B[2] * lqr.u + lqr.A[2,1] * lqr.x[1] + lqr.A[2,2] * lqr.x[2] + lqr.A[2,3] * lqr.x[3] + lqr.A[2,4] * lqr.x[4] + lqr.Kf[2,2] * (lqr.x[3] - control.currentAngle) + lqr.Kf[2,1] * (lqr.x[1] - control.currentPosition);
					lqr.xn[3] := lqr.B[3] * lqr.u + lqr.A[3,1] * lqr.x[1] + lqr.A[3,2] * lqr.x[2] + lqr.A[3,3] * lqr.x[3] + lqr.A[3,4] * lqr.x[4] + lqr.Kf[3,2] * (lqr.x[3] - control.currentAngle) + lqr.Kf[3,1] * (lqr.x[1] - control.currentPosition);
					lqr.xn[4] := lqr.B[4] * lqr.u + lqr.A[4,1] * lqr.x[1] + lqr.A[4,2] * lqr.x[2] + lqr.A[4,3] * lqr.x[3] + lqr.A[4,4] * lqr.x[4] + lqr.Kf[4,2] * (lqr.x[3] - control.currentAngle) + lqr.Kf[4,1] * (lqr.x[1] - control.currentPosition);
					
					lqr.intOut[1] := (lqr.xn[1] * lqr.Ts/2) + lqr.intSave[1];
					lqr.intOut[2] := (lqr.xn[2] * lqr.Ts/2) + lqr.intSave[2];
					lqr.intOut[3] := (lqr.xn[3] * lqr.Ts/2) + lqr.intSave[3];
					lqr.intOut[4] := (lqr.xn[4] * lqr.Ts/2) + lqr.intSave[4];
					
					lqr.intSave[1] := lqr.intOut[1] + (lqr.xn[1] * lqr.Ts / 2);
					lqr.intSave[2] := lqr.intOut[2] + (lqr.xn[2] * lqr.Ts / 2);
					lqr.intSave[3] := lqr.intOut[3] + (lqr.xn[3] * lqr.Ts / 2);
					lqr.intSave[4] := lqr.intOut[4] + (lqr.xn[4] * lqr.Ts / 2);
					
					lqr.x[1] := lqr.intOut[1];
					lqr.x[2] := lqr.intOut[2];
					lqr.x[3] := lqr.intOut[3];
					lqr.x[4] := lqr.intOut[4];
		
				ELSIF hmi.buttons.simulinkPid THEN
					// Simulink has the calculated value for velocity
					control.setVelocity := opcua.setCartVelocity;
					
					// Update the opcua from current simulated reads
					opcua.cartPosition := control.currentPosition;
					opcua.cartVelocity := control.currentVelocity;
					opcua.pendulumAngle := control.currentAngle;
				ELSE
					// No control is set
					control.setVelocity := 0;
		
				END_IF
				//////////////////////
				// CONTROL LOOP END //
				//////////////////////
				
			END_IF
			
		CTRL_NO_SIM:
			
		CTRL_NO_CONTROLLER:
		
	END_CASE;
	//////////////////////
	// STATE SWITCH END //
	//////////////////////
	
	
	///////////////////////
	// SIMULATION WRITES //
	///////////////////////
	IF hmi.buttons.experiorSim THEN
		// Force the motor controls active
		pvi.motor.start := TRUE;
		pvi.motor.forward := control.currentDirection;
		
		// Set the motor velocity from the control type
		IF control.setVelocity > 0 AND control.setVelocity > control.limitVelocity THEN
			pvi.motor.setVelocity := REAL_TO_INT(control.limitVelocity);
		ELSIF control.setVelocity < 0 AND -control.setVelocity > control.limitVelocity THEN
			pvi.motor.setVelocity := -REAL_TO_INT(control.limitVelocity);
		ELSE
			pvi.motor.setVelocity := REAL_TO_INT(control.setVelocity);
		END_IF
		
	ELSIF hmi.buttons.simulinkSim THEN
		// Write the calculated velocity to the opcua type
		opcua.setCartVelocity := control.setVelocity;
		
	END_IF
	//////////////////////////
	// SIMULATION WRITE END //
	//////////////////////////
	
	
	//////////////////
	// HMI UPDATING //
	//////////////////
	hmi.fields.angle := control.currentAngle;
	hmi.fields.position := control.currentPosition;
	hmi.fields.velocity := control.currentVelocity;
	hmi.fields.positionLimitPos := control.homing.foundPosLim;
	hmi.fields.positionLimitNeg := control.homing.foundNegLim;
	hmi.fields.controlState := "Hello!";
	
	//////////////////////
	// HMI UPDATING END //
	//////////////////////
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

