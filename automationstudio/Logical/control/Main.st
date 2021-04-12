
PROGRAM _INIT
	(* Insert code here *)
	
END_PROGRAM

PROGRAM _CYCLIC
	CASE state OF
		CTRL_INIT:
			// Binding the motion axis to MC blocks
			mc.home.Axis := ADR(gAxis);
			mc.moveAbsolute.Axis := ADR(gAxis);
			mc.moveVelocity.Axis := ADR(gAxis);
			mc.power.Axis := ADR(gAxis);
			mc.reset.Axis := ADR(gAxis);
			mc.stop.Axis := ADR(gAxis);
			mc.currentPosition.Axis := ADR(gAxis);
			mc.currentVelocity.Axis := ADR(gAxis);
			mc.error.Axis := ADR(gAxis);
			
			// Setting a few limits
//			gAxis.limit.parameter.a1_pos := gControl.limitAcceleration;
//			gAxis.limit.parameter.a1_neg := gControl.limitAcceleration;
//			gAxis.limit.parameter.a2_pos := gControl.limitAcceleration;
//			gAxis.limit.parameter.a2_neg := gControl.limitAcceleration;
//			gAxis.limit.parameter.v_pos := gControl.limitVelocity;
//			gAxis.limit.parameter.v_neg := gControl.limitVelocity;
//			gAxis.limit.parameter.neg_sw_end := gControl.limitNegPos;
//			gAxis.limit.parameter.pos_sw_end := gControl.limitPosPos;
			
			mc.moveAbsolute.Acceleration := gControl.limitAcceleration;
			mc.moveAbsolute.Deceleration := gControl.limitAcceleration;
			mc.moveAbsolute.Velocity := gControl.limitVelocity;
			mc.moveAbsolute.Direction := mcPOSITIVE_DIR;
			
			mc.moveVelocity.Acceleration := gControl.limitAcceleration;
			mc.moveVelocity.Deceleration := gControl.limitAcceleration;
			mc.moveVelocity.Velocity := gControl.limitVelocity;
			
			// Next state
			state := CTRL_OFF;
			
		CTRL_OFF:
			mc.power.Enable := FALSE;
			mc.currentPosition.Enable := FALSE;
			mc.currentVelocity.Enable := FALSE;
			mc.error.Enable := FALSE;
			mc.status.Enable := FALSE;
			IF hmi.buttons.on THEN
				state := CTRL_POWER_ON_AXIS;
			END_IF
			
		CTRL_POWER_ON_AXIS:
			mc.power.Enable := TRUE;
			mc.currentPosition.Enable := TRUE;
			mc.currentVelocity.Enable := TRUE;
			mc.error.Enable := TRUE;
			mc.status.Enable := TRUE;
			state := CTRL_POWERING_ON_AXIS;
			
		CTRL_POWERING_ON_AXIS:
			IF mc.power.Status THEN
				state := CTRL_HOME_AXIS;
			END_IF
			
		CTRL_POWER_OFF_AXIS:
			mc.power.Enable := FALSE;
			mc.currentPosition.Enable := FALSE;
			mc.currentVelocity.Enable := FALSE;
			mc.error.Enable := FALSE;
			mc.status.Enable := FALSE;
			state := CTRL_POWERING_OFF_AXIS;
			
		CTRL_POWERING_OFF_AXIS:
			IF NOT mc.power.Status AND NOT mc.currentPosition.Valid AND NOT mc.currentVelocity.Valid THEN
				state := CTRL_OFF;
			END_IF
			
		CTRL_HOME_AXIS:
			IF mc.home.Execute THEN
				mc.home.Execute := FALSE;
			ELSE
				mc.home.Execute := TRUE;
				state := CTRL_HOMING_AXIS;
			END_IF
			
			
		CTRL_HOMING_AXIS:
			IF mc.home.Done THEN
				mc.home.Execute := FALSE;
				state := CTRL_STOPPING;
			END_IF
			
		CTRL_STOPPING:
			mc.stop.Execute := TRUE;
			IF mc.stop.Done THEN
				mc.stop.Execute := FALSE;
				state := CTRL_STANDSTILL;
			END_IF
			
		CTRL_STANDSTILL:
			IF hmi.buttons.start THEN
				IF gControl.modeVelocity THEN
					IF gControl.setVelocity > 0 OR gControl.setVelocity < gControl.limitVelocity THEN
						state := CTRL_MOVE_VELOCITY;
					ELSE
						hmi.fields.errorText := "setVelocity is outside allowable limits!";
					END_IF
				ELSE
					state := CTRL_MOVE_ABSOLUTE;
				END_IF
			ELSIF hmi.buttons.off THEN
				state := CTRL_POWER_OFF_AXIS;
			END_IF
			
		CTRL_MOVE_VELOCITY:
			IF hmi.buttons.stop OR NOT gControl.modeVelocity THEN
				mc.moveVelocity.Execute := FALSE;
				state := CTRL_STOPPING;
			ELSE
				IF gControl.setVelocity >= 0 AND gControl.setVelocity < gControl.limitVelocity THEN
					mc.moveVelocity.Velocity := gControl.setVelocity;
					IF gControl.setDirection THEN
						mc.moveVelocity.Direction := mcPOSITIVE_DIR;
					ELSE
						mc.moveVelocity.Direction := mcNEGATIVE_DIR;
					END_IF
					
					IF mc.moveVelocity.Execute THEN
						mc.moveVelocity.Execute := FALSE;
						mc.moveVelocity();
					END_IF
					mc.moveVelocity.Execute := TRUE;
				ELSE
					mc.moveVelocity.Velocity := 0;
					mc.moveVelocity.Execute := FALSE;
					state := CTRL_STOPPING;
				END_IF
			END_IF
			
		CTRL_MOVE_ABSOLUTE:
			IF hmi.buttons.stop OR gControl.modeVelocity THEN
				mc.moveAbsolute.Execute := FALSE;
				state := CTRL_STOPPING;
			ELSIF mc.moveAbsolute.Done THEN
				mc.moveAbsolute.Execute := FALSE;
				state := CTRL_STANDSTILL;
			ELSE
				// Check if move is needed
				IF ABS(gControl.currentPosition - gControl.setPosition) > 0.1 THEN
					mc.moveAbsolute.Position := gControl.setPosition;
					mc.moveAbsolute.Execute := TRUE;
				ELSIF NOT mc.moveAbsolute.Execute AND ABS(gControl.currentPosition - gControl.setPosition) < 0.1 THEN
					mc.moveAbsolute.Execute := FALSE;
					state := CTRL_STANDSTILL;
				END_IF
			END_IF
						
		CTRL_ERROR:
			IF hmi.buttons.ackError THEN
				state := CTRL_INIT;
			END_IF
			
		CTRL_FATAL_ERROR:
			
		CTRL_FATAL_ERROR_EXIT:
		
	END_CASE
	
	// Clearing errorText if ack'ed
	IF hmi.buttons.ackError THEN
		mc.error.Acknowledge := TRUE;
	END_IF
	
	// Updating blocks
	mc.home();
	mc.moveAbsolute();
	mc.moveVelocity();
	mc.power();
	mc.reset();
	mc.stop();
	mc.currentPosition();
	mc.currentVelocity();
	mc.status();
	mc.error();
	
	// Error checking
	// TODO: Do something 
	IF mc.home.Error THEN
	END_IF
	IF mc.moveAbsolute.Error THEN
	END_IF
	IF mc.moveVelocity.Error THEN
	END_IF
	IF mc.power.Error THEN
	END_IF
	IF mc.reset.Error THEN
	END_IF
	IF mc.stop.Error THEN
	END_IF
	IF mc.currentPosition.Error THEN
	END_IF
	IF mc.currentVelocity.Error THEN
	END_IF
	IF mc.status.Error THEN
	END_IF
	
	// Settings gControl variables from function blocks
	gControl.currentAngle := 0; // TODO: Where do I get this? 
	gControl.currentPosition := mc.currentPosition.Position;
	gControl.currentVelocity := mc.currentVelocity.Velocity;
	gControl.modeVelocity := hmi.buttons.moveTypeToggle;
	
	// Updating a ton of limits 
	IF hmi.buttons.setLimits THEN
		gControl.limitAcceleration := hmi.fields.accelerationLimit;
		gControl.limitVelocity := hmi.fields.velocityLimit;
		gControl.limitNegPos := hmi.fields.positionLimitNeg;
		gControl.limitPosPos := hmi.fields.positionLimitPos;
		
		mc.moveAbsolute.Acceleration := gControl.limitAcceleration;
		mc.moveAbsolute.Deceleration := gControl.limitAcceleration;
		mc.moveAbsolute.Velocity := gControl.limitVelocity;
		mc.moveVelocity.Acceleration := gControl.limitAcceleration;
		mc.moveVelocity.Deceleration := gControl.limitAcceleration;
		mc.moveVelocity.Velocity := gControl.limitVelocity;
	END_IF
	
	// Resetting some buttons to false values to eliminate latent erroneous positives
	hmi.buttons.on := FALSE;
	hmi.buttons.off := FALSE;
	hmi.buttons.start := FALSE;
	hmi.buttons.stop := FALSE;
	hmi.buttons.ackError := FALSE;
	hmi.buttons.setLimits := FALSE;
	hmi.buttons.setGearing := FALSE;
	// And an error block thing
	mc.error.Acknowledge := FALSE;
	
	// Updating the vars used in VC
	// Just grabbing some button states for override things
	hmi.overrides.velocity := hmi.buttons.overrideVelocity;
	hmi.overrides.position := hmi.buttons.overridePosition;
	
	// TODO: Finish this
	hmi.fields.velocity := mc.currentVelocity.Velocity;
	hmi.fields.position := mc.currentPosition.Position;
	hmi.fields.angle := 0; // From matlab OPC UA? 
	
	// TODO: Do error checking on overrides
	IF hmi.overrides.velocity AND NOT hmi.overrides.velocityPrevState THEN
		hmi.overrides.velocityPrevState := hmi.overrides.velocity;
		hmi.overrides.velocityStored := mc.moveVelocity.Velocity;
		mc.moveVelocity.Velocity := hmi.fields.ovrVelocity;
		mc.moveAbsolute.Velocity := hmi.fields.ovrVelocity;
	ELSIF NOT hmi.overrides.velocity AND hmi.overrides.velocityPrevState THEN
		hmi.overrides.velocityPrevState := hmi.overrides.velocity;
		mc.moveVelocity.Velocity := hmi.overrides.velocityStored;
		mc.moveAbsolute.Velocity := hmi.overrides.velocityStored;
	END_IF
	IF hmi.overrides.velocity THEN
		gControl.setVelocity := hmi.fields.ovrVelocity;
		gControl.setDirection := hmi.buttons.overrideVelocityDir;
	END_IF
	
	IF hmi.overrides.position AND NOT hmi.overrides.positionPrevState THEN
		hmi.overrides.positionPrevState := hmi.overrides.position;
		hmi.overrides.positionStored := mc.moveAbsolute.Position;
		mc.moveAbsolute.Position := hmi.fields.ovrPosition;
	ELSIF NOT hmi.overrides.position AND hmi.overrides.positionPrevState THEN
		hmi.overrides.positionPrevState := hmi.overrides.position;
		mc.moveAbsolute.Position := hmi.overrides.positionStored;
	END_IF
	IF hmi.overrides.position THEN
		gControl.setPosition := hmi.fields.ovrPosition;
	END_IF
	
	hmi.fields.accelerationLimit := gControl.limitAcceleration;
	hmi.fields.velocityLimit := gControl.limitVelocity;
	hmi.fields.positionLimitPos := gControl.limitNegPos;
	hmi.fields.positionLimitNeg := gControl.limitPosPos;
	
	CASE state OF
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
	
	hmi.indicators.modeMoveAbsolute := NOT gControl.modeVelocity;
	
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

