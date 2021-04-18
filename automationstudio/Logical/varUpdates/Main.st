
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	// Clearing errorText if ack'ed
	IF hmi.buttons.ackError THEN
		// Reset button
		hmi.buttons.ackError := FALSE;
		// Acknowledge error
		mc.error.Acknowledge := TRUE;
	END_IF
	
	// Update the function blocks used for errors and reading values 
	mc.currentPosition();
	mc.currentVelocity();
	mc.status();
	mc.error();	
	
	// Some HMI button logic for determining which sim and PID to use
	IF hmi.buttons.externalSim AND NOT hmi.buttons.externalSimPrevious THEN
		// Mode switched to external sim
		hmi.buttons.externalSimPrevious := hmi.buttons.externalSim;
		hmi.buttons.simulinkSim := NOT hmi.buttons.externalSim;
		hmi.buttons.simulinkSimPrevious := NOT hmi.buttons.externalSim;
	END_IF	
	IF hmi.buttons.simulinkSim AND NOT hmi.buttons.simulinkSimPrevious THEN
		// Mode switched to simulink sim
		hmi.buttons.simulinkSimPrevious := hmi.buttons.simulinkSim;
		hmi.buttons.externalSim := NOT hmi.buttons.simulinkSim;
		hmi.buttons.externalSimPrevious := NOT hmi.buttons.simulinkSim;
	END_IF
	
	IF hmi.buttons.localPid AND NOT hmi.buttons.localPidPrevious THEN
		// Mode switched to local PID
		hmi.buttons.localPidPrevious := hmi.buttons.localPid;
		hmi.buttons.simulinkPid := NOT hmi.buttons.localPid;
		hmi.buttons.simulinkPidPrevious := NOT hmi.buttons.localPid;
	END_IF	
	IF hmi.buttons.simulinkPid AND NOT hmi.buttons.simulinkPidPrevious THEN
		// Mode switched to simulink PID
		hmi.buttons.simulinkPidPrevious := hmi.buttons.simulinkPid;
		hmi.buttons.localPid := NOT hmi.buttons.simulinkPid;
		hmi.buttons.localPidPrevious := NOT hmi.buttons.simulinkPid;
	END_IF
	
	// Update variables from motor position, velocity, and pendulum angle
	gControl.currentAngle := 0; // TODO: Where do I get this? 
	gControl.currentPosition := mc.currentPosition.Position;
	gControl.currentVelocity := mc.currentVelocity.Velocity;
	gControl.currentDirection := mc.moveVelocity.Direction;
	
	// Update variables from simulation through PVI
	IF hmi.buttons.externalSim THEN
		// Read the current pendulum angle and cart position? from PVI
		// TODO: Scale this correctly
		gControl.currentAngle := DINT_TO_REAL(pvi.pendulumAngle);
		// TODO: I don't think we should let pvi override the MC block position? 
		//gControl.currentPosition := pvi.cartPositionEncoder;
		// Write the current motor state, direction and velocity to PVI
		pvi.motor.start := mc.moveVelocity.Execute;
		pvi.motor.setVelocity := REAL_TO_INT(mc.moveVelocity.Velocity);
		IF mc.moveVelocity.Direction = mcPOSITIVE_DIR THEN
			pvi.motor.forward := TRUE;
		ELSE
			pvi.motor.forward := FALSE;
		END_IF
		
	END_IF
	// Update variables for simulink simulation
	IF hmi.buttons.simulinkSim THEN
		// Read the current pendulum angle from OPCUA
		gControl.currentAngle := opcua_w.pendulumAngle;
		// Write the position and cart velocity to OPCUA
		// TODO: Scale the written velocity correctly
		opcua_w.cartPosition := gControl.currentPosition;
		opcua_w.cartVelocity := gControl.currentVelocity;
	END_IF
	
	// Update variables for local PID control?
	IF hmi.buttons.localPid THEN
	END_IF
	// Update variables for simulink PID control
	IF hmi.buttons.simulinkPid THEN
		// Write the current position and angle
		// Read the new setVelocity
		gControl.setVelocity := opcua_r.setCartVelocity;
		// Write the current position and pendulum angle to OPCUA
		opcua_w.cartPosition := gControl.currentPosition;
		// TODO: Map the velocity correctly
		opcua_w.cartVelocity := gControl.currentVelocity;
		opcua_w.pendulumAngle := gControl.currentAngle;
	END_IF
	
	// Set movement limits from gControl struct
	mc.moveAbsolute.Acceleration := gControl.limitAcceleration;
	mc.moveAbsolute.Deceleration := gControl.limitAcceleration;
	mc.moveAbsolute.Velocity := gControl.limitVelocity;
	mc.moveVelocity.Acceleration := gControl.limitAcceleration;
	mc.moveVelocity.Deceleration := gControl.limitAcceleration;
	
	// And an error block thing
	mc.error.Acknowledge := FALSE;
	
	// Update HMI fields and indicators
	CASE ctrlState OF
		CTRL_INIT:
			hmi.fields.controlState := "CTRL_INIT";
		CTRL_OFF:
			hmi.fields.controlState := "CTRL_OFF";
		CTRL_POWER_ON_AXIS:
			hmi.fields.controlState := "CTRL_POWER_ON_AXIS";
		CTRL_POWERING_ON_AXIS:
			hmi.fields.controlState := "CTRL_POWERING_ON_AXIS";
		CTRL_POWER_OFF_AXIS:
			hmi.fields.controlState := "CTRL_POWER_OFF_AXIS";
		CTRL_POWERING_OFF_AXIS:
			hmi.fields.controlState := "CTRL_POWERING_OFF_AXIS";
		CTRL_HOME_AXIS:
			hmi.fields.controlState := "CTRL_HOME_AXIS";
		CTRL_HOMING_AXIS:
			hmi.fields.controlState := "CTRL_HOMING_AXIS";
		CTRL_STOPPING:
			hmi.fields.controlState := "CTRL_STOPPING";
		CTRL_STANDSTILL:
			hmi.fields.controlState := "CTRL_STANDSTILL";
		CTRL_MOVE_VELOCITY:
			hmi.fields.controlState := "CTRL_MOVE_VELOCITY";
		CTRL_MOVE_ABSOLUTE:
			hmi.fields.controlState := "CTRL_MOVE_ABSOLUTE";
		CTRL_ERROR:
			hmi.fields.controlState := "CTRL_ERROR";
		CTRL_FATAL_ERROR:
			hmi.fields.controlState := "CTRL_FATAL_ERROR";
		CTRL_FATAL_ERROR_EXIT:
			hmi.fields.controlState := "CTRL_FATAL_ERROR_EXIT";
		ELSE
			hmi.fields.controlState := "State fell through HMI Case!";
	END_CASE
		
	hmi.fields.errorCode := mc.error.ErrorID;
	hmi.fields.errorText := STRING_TO_WSTRING(mc.error.DataObjectName);
	
	hmi.fields.accelerationLimit := gControl.limitAcceleration;
	hmi.fields.velocityLimit := gControl.limitVelocity;
	hmi.fields.positionLimitPos := gControl.limitNegPos;
	hmi.fields.positionLimitNeg := gControl.limitPosPos;
	
	hmi.fields.angle := gControl.currentAngle;
	hmi.fields.position := gControl.currentPosition;
	hmi.fields.velocity := gControl.currentVelocity;
	
	hmi.indicators.power := mc.power.Error OR NOT mc.power.Enable;
	hmi.indicators.home := mc.home.Error OR NOT mc.home.Busy;
	hmi.indicators.stop := mc.stop.Error OR NOT mc.stop.Busy;
	hmi.indicators.reset := mc.reset.Error OR NOT mc.reset.Execute;
	hmi.indicators.moveVelocity := mc.moveVelocity.Error OR NOT mc.moveVelocity.Execute;
	hmi.indicators.movePosition := mc.moveAbsolute.Error OR NOT mc.moveAbsolute.Execute;
	hmi.indicators.readVelocity := mc.currentVelocity.Error OR NOT mc.currentVelocity.Enable;
	hmi.indicators.readPosition := mc.currentPosition.Error OR NOT mc.currentPosition.Enable;
	hmi.indicators.status := mc.status.Error AND NOT mc.status.Enable;
	hmi.indicators.error := mc.error.Error AND NOT mc.error.Enable;	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

